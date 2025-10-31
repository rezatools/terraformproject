resource "azurerm_key_vault" "shared" {
  name                       = "${var.shared_resource_prefix}kv-${var.environment}-${substr(md5("${var.resource_group_name}"), 0, 6)}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
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

  tags = var.tags
}

data "azurerm_client_config" "current" {}

