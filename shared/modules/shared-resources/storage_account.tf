resource "azurerm_storage_account" "file_mounts" {
  name                     = "${var.shared_resource_prefix}sa${replace(var.environment, "-", "")}${substr(replace(lower(var.resource_group_name), "-", ""), 0, 12), 0, 12)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "file_mounts" {
  name                  = "file-mounts"
  storage_account_name  = azurerm_storage_account.file_mounts.name
  container_access_type = "private"
}

