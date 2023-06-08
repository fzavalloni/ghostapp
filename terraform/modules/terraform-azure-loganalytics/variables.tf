variable "location" {
  description = "(Required). The location of the cluster. Optional value are `az account list-locations -o table`"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "(Optional). Any tags that should be defined on resources"
  default     = {}
}

variable "resource_group_name" {
  description = "(Required).The resource group name of the cluster"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "(Required) Workspace Name"
  type        = string  
} 

variable "log_analytics_workspace_sku" {
  description = "(Optional). The SKU (pricing level) of the Log Analytics workspace.  Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "(Optional). The retention period for the logs in days"
  type        = number
  default     = 30
}

variable "log_daily_quota_gb" {
  description = "(Optional). The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted"
  type        = number
  default     = -1
}
