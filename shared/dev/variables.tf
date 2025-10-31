variable "resource_group_name" {
  description = "Name of the resource group for dev shared resources"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "group_users_object_id" {
  description = "Object ID of the Azure AD group 'group_users'"
  type        = string
}

variable "shared_resource_prefix" {
  description = "Prefix for shared resource names"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

