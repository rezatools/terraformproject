# Log Analytics Workspace - Required for Container Apps Environment
# Using PerGB2018 SKU (pay-per-GB) which is cheapest for infrequent logging (1-2 runs/day)
# Retention set to 7 days minimum to keep costs low; logs are archived to blob storage
resource "azurerm_log_analytics_workspace" "client" {
  name                = "law-${var.client_name}-${substr(md5(azurerm_resource_group.client.name), 0, 6)}"
  location            = azurerm_resource_group.client.location
  resource_group_name = azurerm_resource_group.client.name
  sku                 = "PerGB2018"  # Pay-per-GB pricing (~$2.30/GB), cheapest for low-volume logging
  retention_in_days   = 7  # Minimal retention (minimum allowed); logs archived to blob storage for long-term

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

# Create container for logs in parquet storage account (reuses existing storage for cost efficiency)
resource "azurerm_storage_container" "logs" {
  name                  = "container-logs"
  storage_account_name  = azurerm_storage_account.parquet_files.name
  container_access_type = "private"
}

# Diagnostic settings to forward environment/platform logs to blob storage
# Note: Application logs from container apps are captured via Log Analytics workspace
# This diagnostic setting archives platform logs to blob storage for long-term, cost-effective storage
# Logs are automatically exported to blob storage in path: insights-logs-{category}/
resource "azurerm_monitor_diagnostic_setting" "container_env_logs" {
  name              = "container-env-logs-to-blob"
  target_resource_id = azurerm_container_app_environment.client.id
  storage_account_id = azurerm_storage_account.parquet_files.id

  # Container App Environment platform logs
  log {
    category = "ContainerAppConsoleLogs"
    enabled  = true

    retention_policy {
      enabled = false  # Blob storage lifecycle policies handle retention (cheaper than Log Analytics retention)
    }
  }

  log {
    category = "ContainerAppSystemLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

