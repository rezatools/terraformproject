# Storage Blob Data Contributor for file mounts storage account
resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.file_mounts.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.group_users_object_id
}

# Azure Container Registry Contributor (includes AcrPush, AcrPull, AcrDelete)
resource "azurerm_role_assignment" "acr_contributor" {
  scope                = azurerm_container_registry.shared.id
  role_definition_name = "AcrPush"
  principal_id         = var.group_users_object_id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.shared.id
  role_definition_name = "AcrPull"
  principal_id         = var.group_users_object_id
}

resource "azurerm_role_assignment" "acr_delete" {
  scope                = azurerm_container_registry.shared.id
  role_definition_name = "AcrDelete"
  principal_id         = var.group_users_object_id
}

# Key Vault Secrets Officer (allows create, update, delete secrets)
resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_key_vault.shared.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.group_users_object_id
}

# Key Vault Secrets User (allows read secrets)
resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = azurerm_key_vault.shared.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.group_users_object_id
}

