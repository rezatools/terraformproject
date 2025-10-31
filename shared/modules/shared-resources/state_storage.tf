resource "azurerm_storage_account" "terraform_state" {
  name                     = "${var.shared_resource_prefix}tfstate${replace(var.environment, "-", "")}${substr(md5("${var.resource_group_name}"), 0, 8)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # Enable versioning and soft delete for state files
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }

  tags = merge(var.tags, {
    Purpose = "TerraformState"
  })
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

