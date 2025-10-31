output "resource_group_name" {
  description = "Name of the client resource group"
  value       = module.client_resources.resource_group_name
}

output "key_vault_name" {
  description = "Name of the client Key Vault"
  value       = module.client_resources.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the client Key Vault"
  value       = module.client_resources.key_vault_uri
}

output "storage_account_name" {
  description = "Name of the storage account for parquet files"
  value       = module.client_resources.storage_account_name
}

output "parquet_container_name" {
  description = "Name of the container for parquet files"
  value       = module.client_resources.parquet_container_name
}

output "container_environment_name" {
  description = "Name of the Azure Container Environment"
  value       = module.client_resources.container_environment_name
}

