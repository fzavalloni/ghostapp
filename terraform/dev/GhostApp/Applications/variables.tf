variable "location" {
  description = "location in which resources are going to be deployed"
  type        = string
}

variable "tenant_id" {
  description = "ID of the tenant"
  type        = string
}

variable "subs_id" {
  description = "ID of the subscription inside the tenant"
  type        = string
}

variable "ghost_app_password" {
  description = "Ghost Application Password"
  type        = string
}
