output "resource_group_name" {
  description = "Name of the client resource group"
  value       = azurerm_resource_group.client.name
}

output "resource_group_id" {
  description = "ID of the client resource group"
  value       = azurerm_resource_group.client.id
}

output "key_vault_id" {
  description = "ID of the client Key Vault"
  value       = azurerm_key_vault.client.id
}

output "key_vault_name" {
  description = "Name of the client Key Vault"
  value       = azurerm_key_vault.client.name
}

output "key_vault_uri" {
  description = "URI of the client Key Vault"
  value       = azurerm_key_vault.client.vault_uri
}

output "storage_account_id" {
  description = "ID of the storage account for parquet files"
  value       = azurerm_storage_account.parquet_files.id
}

output "storage_account_name" {
  description = "Name of the storage account for parquet files"
  value       = azurerm_storage_account.parquet_files.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.parquet_files.primary_blob_endpoint
}

output "parquet_container_name" {
  description = "Name of the container for parquet files"
  value       = azurerm_storage_container.parquet_files.name
}

output "container_environment_id" {
  description = "ID of the Azure Container Environment"
  value       = azurerm_container_app_environment.client.id
}

output "container_environment_name" {
  description = "Name of the Azure Container Environment"
  value       = azurerm_container_app_environment.client.name
}

