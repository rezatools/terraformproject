# Storage Blob Data Contributor for parquet files storage account
resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.parquet_files.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.group_users_object_id
}

# Storage Blob Contributor for blob storage management
resource "azurerm_role_assignment" "storage_blob_contributor" {
  scope                = azurerm_storage_account.parquet_files.id
  role_definition_name = "Storage Blob Contributor"
  principal_id         = var.group_users_object_id
}

# ACR Pull - allows pulling images from shared ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.shared_acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.group_users_object_id
}

# Container Apps Contributor - allows creating and managing container apps/jobs
resource "azurerm_role_assignment" "container_apps_contributor" {
  scope                = azurerm_resource_group.client.id
  role_definition_name = "Container Apps Contributor"
  principal_id         = var.group_users_object_id
}

# Container Apps Operator - allows scheduling and managing jobs
resource "azurerm_role_assignment" "container_apps_operator" {
  scope                = azurerm_resource_group.client.id
  role_definition_name = "Container Apps Operator"
  principal_id         = var.group_users_object_id
}

# Key Vault Secrets Officer (allows create, update, delete secrets)
resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_key_vault.client.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.group_users_object_id
}

# Key Vault Secrets User (allows read secrets)
resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = azurerm_key_vault.client.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.group_users_object_id
}

