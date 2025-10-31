resource "azurerm_container_registry" "shared" {
  name                = "${var.shared_resource_prefix}acr${replace(var.environment, "-", "")}${substr(md5("${var.resource_group_name}"), 0, 6)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true

  tags = var.tags
}

