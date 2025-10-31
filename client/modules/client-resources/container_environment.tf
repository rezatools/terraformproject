resource "azurerm_log_analytics_workspace" "client" {
  name                = "law-${var.client_name}-${substr(md5(azurerm_resource_group.client.name), 0, 6)}"
  location            = azurerm_resource_group.client.location
  resource_group_name = azurerm_resource_group.client.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(var.tags, {
    Client = var.client_name
  })
}

resource "azurerm_container_app_environment" "client" {
  name                       = "cae-${var.client_name}-${substr(md5(azurerm_resource_group.client.name), 0, 6)}"
  location                   = azurerm_resource_group.client.location
  resource_group_name        = azurerm_resource_group.client.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.client.id

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Configure registry credentials to pull from shared ACR
  registry {
    server   = var.shared_acr_login_server
    identity = "system-assigned"
  }

  tags = merge(var.tags, {
    Client = var.client_name
  })
}

# Grant the container app environment's managed identity AcrPull on shared ACR
resource "azurerm_role_assignment" "container_env_acr_pull" {
  scope                = var.shared_acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app_environment.client.identity[0].principal_id
}

