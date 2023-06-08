variable "location" {
  description = "Azure Location"
  type        = string
}

variable "tenant_id" {
  description = "Azure Active Directory Tenant ID"
  type        = string
}

variable "subs_id" {
  description = "Subscription ID"
  type        = string
}

variable "environment-prefix" {
  description = "Environment Prefix. Ex: GhosApp-, or BlogApp-"
  type        = string
}

variable "ghost_app_password" {
  description = "Ghost Application Password"
  type        = string
}