resource "azurerm_key_vault" "client" {
  name                       = "kv-${var.client_name}-${substr(md5(azurerm_resource_group.client.name), 0, 6)}"
  location                   = azurerm_resource_group.client.location
  resource_group_name        = azurerm_resource_group.client.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  enabled_for_disk_encryption      = false

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = merge(var.tags, {
    Client = var.client_name
  })
}

data "azurerm_client_config" "current" {}

