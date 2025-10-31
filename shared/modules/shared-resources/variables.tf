variable "resource_group_name" {
  description = "Name of the resource group for shared resources"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
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
  default     = {}
}

