output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.shared_resources.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.shared_resources.key_vault_name
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry"
  value       = module.shared_resources.container_registry_name
}

output "container_registry_id" {
  description = "Resource ID of the Azure Container Registry"
  value       = module.shared_resources.container_registry_id
}

output "container_registry_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = module.shared_resources.container_registry_login_server
}

output "storage_account_name" {
  description = "Name of the storage account for file mounts"
  value       = module.shared_resources.storage_account_name
}

output "state_storage_account_name" {
  description = "Name of the storage account for Terraform state"
  value       = module.shared_resources.state_storage_account_name
}

