resource "azurerm_storage_account" "parquet_files" {
  name                     = "sa${replace(var.client_name, "-", "")}${substr(md5(azurerm_resource_group.client.name), 0, 8)}"
  resource_group_name      = azurerm_resource_group.client.name
  location                 = azurerm_resource_group.client.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = merge(var.tags, {
    Client  = var.client_name
    Purpose = "ParquetFiles"
  })
}

resource "azurerm_storage_container" "parquet_files" {
  name                  = "parquet-files"
  storage_account_name  = azurerm_storage_account.parquet_files.name
  container_access_type = "private"
}

