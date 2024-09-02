variable "instance_name" {
  description = "(Required) The name of this managed Grafana instance."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group to create the resources in."
  type        = string
}
variable "location" {
  description = "(Required) The location to create the resources in."
  type        = string
}
variable "grafana_major_version" {
  description = "(Optional) Which major version of Grafana to deploy."
  type        = number
  default     = 10
}
variable "sku" {
  description = "(Optional) Specifies the service SKU"
  type        = string
  default     = "Essential"

  validation {
    condition     = can(regex("^Essential|Standard$", var.sku))
    error_message = "Invalid SKU. Accepted values are 'Essential' or 'Standard'."
  }
}
variable "log_analytics_destination_type" {
  description = "(Optional) Set the Log Analytics storage to use the built-in AzureDiagnostics table or create dedicated tables for this resource. Defaults to `AzureDiagnostics`."
  type        = string
  default     = "AzureDiagnostics"

  validation {
    condition     = can(regex("^AzureDiagnostics|Dedicated$", var.log_analytics_destination_type))
    error_message = "Invalid log analytics destination type. Accepted values are 'AzureDiagnostics' or 'Dedicated'."
  }
}
variable "api_key_enabled" {
  description = "(Optional) Enable service access API"
  type        = bool
  default     = false
}
variable "public_network_access_enabled" {
  description = "(Optional) Enable public_network_access_enabled"
  type        = bool
  default     = false
}
variable "zone_redundancy_enabled" {
  description = "(Optional) Enable zone_redundancy_enabled"
  type        = bool
  default     = false
}
variable "identity_type" {
  description = "(Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, a `user_assigned_identity_id` must be set as well. Defaults to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}
variable "deterministic_outbound_ip_enabled" {
  description = "(Optional) Specifies the deterministic_outbound_ip_enabled"
  type        = bool
  default     = false
}
variable "azure_monitor_workspace_integrations" {
  description = "(Optional) Specifies the resources with the Workspace integration. It is necessary for the Grafana/Prometheus integration."
  type = list(object({
    resource_id = string
  }))
  default = []
}
variable "tags" {
  description = "(Optional) A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}