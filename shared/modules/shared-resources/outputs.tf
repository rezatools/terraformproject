output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.shared.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.shared.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.shared.vault_uri
}

output "container_registry_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.shared.id
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.shared.name
}

output "container_registry_login_server" {
  description = "Login server URL of the Azure Container Registry"
  value       = azurerm_container_registry.shared.login_server
}

output "storage_account_id" {
  description = "ID of the storage account for file mounts"
  value       = azurerm_storage_account.file_mounts.id
}

output "storage_account_name" {
  description = "Name of the storage account for file mounts"
  value       = azurerm_storage_account.file_mounts.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.file_mounts.primary_blob_endpoint
}

output "state_storage_account_id" {
  description = "ID of the storage account for Terraform state"
  value       = azurerm_storage_account.terraform_state.id
}

output "state_storage_account_name" {
  description = "Name of the storage account for Terraform state"
  value       = azurerm_storage_account.terraform_state.name
}

output "state_storage_container_name" {
  description = "Name of the container for Terraform state"
  value       = azurerm_storage_container.terraform_state.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = var.resource_group_name
}

