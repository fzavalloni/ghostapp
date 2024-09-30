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

variable "application_gateway_containers_name" {
  description = "Name of the Application Gateway for Containers within the AKS"
  type        = string
}

variable "application_gateway_containers_namespace" {
  description = "Namespace of the Application Gateway for Containers within the AKS"
  type        = string
}