# Example client deployment template
# Copy this directory for each new client and customize terraform.tfvars

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Configure backend for client state
    # storage_account_name = "<shared-state-storage-account>"
    # container_name       = "terraform-state"
    # key                  = "client/{client-name}/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

module "client_resources" {
  source = "../../modules/client-resources"

  client_name            = var.client_name
  location              = var.location
  group_users_object_id = var.group_users_object_id
  shared_acr_login_server = var.shared_acr_login_server
  shared_acr_id         = var.shared_acr_id
  tags                  = var.tags
}

