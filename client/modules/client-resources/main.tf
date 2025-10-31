# Client Resources Module
# This module creates client-specific infrastructure resources

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_resource_group" "client" {
  name     = "rg-${var.client_name}"
  location = var.location

  tags = merge(var.tags, {
    Client = var.client_name
  })
}

