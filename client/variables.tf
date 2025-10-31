variable "client_name" {
  description = "Name of the client (used in resource group name: rg-{client-name})"
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

variable "shared_acr_login_server" {
  description = "Login server URL of the shared Azure Container Registry"
  type        = string
}

variable "shared_acr_id" {
  description = "Resource ID of the shared Azure Container Registry"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}

