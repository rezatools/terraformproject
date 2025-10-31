# Azure Terraform Multi-Environment Project

This Terraform project manages shared infrastructure resources (dev/prod environments) and provides a reusable module for deploying client-specific resources in Azure.

## Project Structure

```
terraformproject/
├── shared/                          # Root module for shared infrastructure
│   ├── dev/                         # Dev environment shared resources
│   ├── prod/                        # Prod environment shared resources
│   └── modules/
│       └── shared-resources/        # Reusable module for shared resources
├── client/                          # Root module for client deployments
│   ├── modules/
│   │   └── client-resources/        # Reusable module for client resources
│   └── examples/
│       └── client-template/         # Example client instantiation
└── versions.tf                      # Common provider version constraints
```

## Architecture Overview

### Shared Resources (Dev/Prod)

Each environment (dev/prod) deploys:
- **Key Vault**: Centralized secret management
- **Azure Container Registry (ACR)**: Shared container image repository
- **Storage Account**: Blob storage for file mounts to Azure Container Jobs
- **State Storage**: Storage account and container for Terraform state management

### Client Resources

Each client deployment creates a resource group (`rg-{client-name}`) with:
- **Key Vault**: Client-specific secret management
- **Blob Storage**: Storage account with container for parquet files
- **Azure Container Environment**: Environment for running Azure Container Jobs
  - Configured to pull images from shared ACR
  - Supports scheduled and manual job execution

### RBAC Permissions

The `group_users` Azure AD group receives the following permissions:

**Shared Resource Group:**
- Storage Blob Data Contributor (for blob storage)
- AcrPush, AcrPull, AcrDelete (for ACR image management)
- Key Vault Secrets User + Key Vault Secrets Officer (for secret management)

**Client Resource Group:**
- Storage Blob Data Contributor + Storage Blob Contributor
- AcrPull (to pull images from shared ACR)
- Container Apps Contributor + Container Apps Operator (for jobs/environments)
- Key Vault Secrets User + Key Vault Secrets Officer

## Prerequisites

1. **Azure CLI** installed and authenticated
2. **Terraform** >= 1.0 installed
3. **Azure AD Group**: `group_users` group created with known Object ID
4. **Azure Subscription**: Active subscription with appropriate permissions

## Getting Started

### 1. Deploy Shared Resources (Dev)

```bash
cd shared/dev

# Initialize Terraform
terraform init \
  -backend-config="storage_account_name=<state-storage-account>" \
  -backend-config="container_name=terraform-state" \
  -backend-config="key=shared/dev/terraform.tfstate" \
  -backend-config="resource_group_name=<state-rg-name>"

# Review the plan
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars
```

### 2. Deploy Shared Resources (Prod)

```bash
cd shared/prod

# Initialize Terraform
terraform init \
  -backend-config="storage_account_name=<state-storage-account>" \
  -backend-config="container_name=terraform-state" \
  -backend-config="key=shared/prod/terraform.tfstate" \
  -backend-config="resource_group_name=<state-rg-name>"

# Review the plan
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars
```

**Important:** After deploying shared resources, note the ACR outputs:
- `container_registry_login_server`
- `container_registry_id`

These values are required for client deployments.

### 3. Deploy Client Resources

For each new client:

```bash
# Option 1: Use the example template
cp -r client/examples/client-template client/{client-name}
cd client/{client-name}

# Option 2: Use the root client module directly
cd client

# Copy and customize terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with client-specific values

# Initialize Terraform
terraform init \
  -backend-config="storage_account_name=<state-storage-account>" \
  -backend-config="container_name=terraform-state" \
  -backend-config="key=client/{client-name}/terraform.tfstate" \
  -backend-config="resource_group_name=<state-rg-name>"

# Review the plan
terraform plan -var-file=terraform.tfvars

# Apply the configuration
terraform apply -var-file=terraform.tfvars
```

## Required Variables

### Shared Resources (dev/prod)

- `resource_group_name`: Name of the resource group for shared resources
- `location`: Azure region (default: `eastus`)
- `group_users_object_id`: Object ID of the Azure AD group `group_users`
- `shared_resource_prefix`: (Optional) Prefix for shared resource names
- `tags`: (Optional) Tags to apply to resources

### Client Resources

- `client_name`: Name of the client (resource group will be `rg-{client-name}`)
- `location`: Azure region (default: `eastus`)
- `group_users_object_id`: Object ID of the Azure AD group `group_users`
- `shared_acr_login_server`: Login server URL from shared ACR deployment
- `shared_acr_id`: Resource ID from shared ACR deployment
- `tags`: (Optional) Tags to apply to resources

## Getting Azure AD Group Object ID

To get the Object ID of the `group_users` Azure AD group:

```bash
az ad group show --group "group_users" --query id -o tsv
```

Or via Azure Portal:
1. Navigate to Azure Active Directory > Groups
2. Find `group_users`
3. Copy the Object ID from the Overview page

## Outputs

### Shared Resources Outputs

- `key_vault_id`, `key_vault_name`, `key_vault_uri`
- `container_registry_id`, `container_registry_name`, `container_registry_login_server`
- `storage_account_id`, `storage_account_name`
- `state_storage_account_name`, `state_storage_container_name`

### Client Resources Outputs

- `resource_group_name`, `resource_group_id`
- `key_vault_id`, `key_vault_name`, `key_vault_uri`
- `storage_account_name`, `parquet_container_name`
- `container_environment_name`

## CI/CD Integration

### Shared Resources (GitHub Actions)

The shared resources are designed to be deployed via GitHub Actions pipeline. Example workflow:

```yaml
name: Deploy Shared Resources
on:
  push:
    branches: [main]
    paths:
      - 'shared/**'

jobs:
  deploy-dev:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      - uses: hashicorp/terraform-setup-action@v2
      - run: |
          cd shared/dev
          terraform init
          terraform plan
          terraform apply -auto-approve
```

### Client Resources (Azure DevOps)

Client resources are intended for manual execution from Azure DevOps. Each client should have its own pipeline or manual runbook that:

1. Checks out the repository
2. Initializes Terraform with client-specific backend configuration
3. Plans and applies the client module

## Resource Naming Conventions

- **Resource Groups**: `rg-{client-name}` for clients, specified for shared resources
- **Key Vaults**: `kv-{prefix}-{env}-{hash}` for shared, `kv-{client-name}-{hash}` for clients
- **Storage Accounts**: `sa{env}{hash}` for shared, `sa{client}{hash}` for clients
- **ACR**: `acr{env}{hash}` for shared resources
- **Container Environments**: `cae-{client-name}-{hash}`

## Security Considerations

- Key Vaults use soft delete with 7-day retention
- Storage accounts use TLS 1.2 minimum
- Network ACLs on Key Vaults allow Azure Services by default
- RBAC permissions are scoped to resource group level
- Container environments use system-assigned managed identity for ACR access

## Troubleshooting

### Terraform State Issues

If you need to migrate or reinitialize state:

```bash
terraform init -migrate-state
```

### RBAC Permission Issues

Verify the `group_users` Object ID is correct:

```bash
az ad group show --group "group_users"
```

Check role assignments:

```bash
az role assignment list --assignee <group-object-id> --scope <resource-id>
```

### ACR Access Issues

Ensure the container environment's managed identity has `AcrPull` on the shared ACR. This is automatically configured, but verify with:

```bash
az role assignment list --scope <acr-resource-id>
```

## Contributing

When adding new clients:
1. Use the client template in `client/examples/client-template`
2. Copy to a new directory: `client/{client-name}`
3. Customize `terraform.tfvars` with client-specific values
4. Ensure backend configuration points to the correct state location

## License

This project is managed via Terraform and follows infrastructure-as-code best practices.

