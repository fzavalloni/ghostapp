#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Variables
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Resource Group and Locations
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "resource_group_name" {
  description = "(Required) The name of the Azure Resource Group."
  type        = string
}
variable "location" {
  description = "(Required) The Azure location where the resources will be created."
  type        = string
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Data Protection Backup vault
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "vault_name" {
  description = "(Required) The name of the Azure Data Protection Backup Vault."
  type        = string
}
variable "datastore_type" {
  description = "(Required) Specifies the type of the data store. Possible values are ArchiveStore, SnapshotStore and VaultStore. Changing this forces a new resource to be created."
  type        = string
  default     = "VaultStore"
  validation {
    condition     = contains(["VaultStore", "ArchiveStore", "SnapshotStore"], var.datastore_type)
    error_message = "Invalid input, options: \"VaultStore\", \"ArchiveStore\" and \"SnapshotStore\" ."
  }
}
variable "identity_type" {
  description = "(Required) Specifies the identity type of the Backup Vault. Possible value is SystemAssigned"
  type        = string
  default     = null
  validation {
    condition     = contains(["SystemAssigned", null], var.identity_type)
    error_message = "Invalid input, options: \"SystemAssigned\", \"null\"."
  }
}
variable "redundancy" {
  description = "(Required) Specifies the backup storage redundancy. Possible values are GeoRedundant and LocallyRedundant. Changing this forces a new Backup Vault to be created."
  type        = string
  default     = "LocallyRedundant"
  validation {
    condition     = contains(["LocallyRedundant", "GeoRedundant"], var.redundancy)
    error_message = "Invalid input, options: \"LocallyRedundant\", \"GeoRedundant\"."
  }
}
variable "retention_duration_in_days" {
  description = "(Optional) The soft delete retention duration for this Backup Vault. Possible values are between 14 and 180. Defaults to `14`."
  type        = number
  default     = 14
  validation {
    condition     = var.retention_duration_in_days == null || (var.retention_duration_in_days >= 1 && var.retention_duration_in_days <= 365)
    error_message = "Retention duration in days must be between 1 and 365, inclusive, or null."
  }
}
variable "soft_delete" {
  description = "(Optional) The state of soft delete for this Backup Vault. Possible values are AlwaysOn, Off and On. Defaults to `On`. The retention_duration_in_days is the number of days for which deleted data is retained before being permanently deleted. Retention period till 14 days are free of cost, however, retention beyond 14 days may incur additional charges. The retention_duration_in_days is required when the soft_delete is set to On."
  type        = string
  default     = "On"
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Data Protection Backup Policy Blob Storage
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "backup_policies" {
  description = "(Optional) The name of the Azure Data Protection Backup Policy for Blob Storage."
  type = map(object({
    name               = string
    retention_duration = string # Duration of deletion after given timespan. It should follow ISO 8601 duration format. Ex "P30D", 
  }))
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Tagging
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "tags" {
  description = "(Optional) Any tags that should be defined on resources"
  type        = map(string)
  default     = {}
}
