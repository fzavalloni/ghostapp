variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Log Analytics Workspace."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Log Analytics Workspace."
  type        = string
  nullable    = false
}
variable "log_analytics_workspace_name" {
  description = "(Required) The name for this Azure Log Analytics Workspace."
  type        = string
  nullable    = false
}
variable "log_analytics_workspace_sku" {
  description = "(Optional). The SKU (pricing level) of this Azure Log Analytics Workspace.  Possible values are `Free`, `PerNode`, `Premium`, `Standard`, `Standalone`, `Unlimited`, `CapacityReservation`, and `PerGB2018`. Defaults to `PerGB2018`."
  type        = string
  default     = "PerGB2018"
}
variable "log_retention_in_days" {
  description = "(Optional). The retention period for the logs in days. Defaults to `30`."
  type        = number
  default     = 30
}
variable "log_daily_quota_gb" {
  description = "(Optional). The daily quota for ingestion in GB. If omitted this value is unlimited. Defaults to `-1`."
  type        = number
  default     = -1
}
variable "log_reservation_capacity_in_gb_per_day" {
  description = "(Optional) The capacity reservation level in GB for this workspace. Possible values are 100, 200, 300, 400, 500, 1000, 2000 and 5000. Defaults to `Null`"
  type        = number
  default     = null
}
variable "create_log_analytics_query_pack" {
  description = "Enable or disable the creation of Log Analytics Query Pack."
  type        = bool
  default     = false
}
variable "query_pack_name" {
  description = "(Required) The name which should be used for this Log Analytics Query Pack. Changing this forces a new resource to be created."
  type        = string
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
