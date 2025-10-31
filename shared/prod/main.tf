terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Backend configuration should be provided via backend config file or CLI
    # storage_account_name = "tfstateprod..."
    # container_name       = "terraform-state"
    # key                  = "shared/prod/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

module "shared_resources" {
  source = "../modules/shared-resources"

  resource_group_name    = var.resource_group_name
  location              = var.location
  environment           = "prod"
  group_users_object_id = var.group_users_object_id
  shared_resource_prefix = var.shared_resource_prefix
  tags                  = var.tags
}

