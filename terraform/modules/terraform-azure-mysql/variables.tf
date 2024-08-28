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
  description = "(Required) Name of the resource group to be used when creating this Azure MySQL Flexible Server."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure MySQL Flexible Server."
  type        = string
  nullable    = false
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Azure MySQL Flexible Server
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "(Required) The name for this Azure MySQL Flexible Server."
  type        = string
  nullable    = false
}
variable "auto_grow_enable" {
  description = "(Optional) Should Storage Auto Grow be enabled? Defaults to `true`."
  type        = bool
  default     = true
}
variable "storage_size_gb" {
  description = "(Optional) The max storage allowed for this Azure MySQL Flexible Server. Possible values are between `20` and `16384`. Defaults to `32`."
  type        = number
  default     = 32
}
variable "storage_iops" {
  description = "(Optional) The storage IOPS for this Azure MySQL Flexible Server. Possible values are between `360` and `20000`. Defaults to `369`."
  type        = number
  default     = 396
}
variable "backup_retention_days" {
  description = "(Optional) The backup retention days for this Azure MySQL Flexible Server. Possible values are between `1` and `35` days. Defaults to `30`."
  type        = number
  default     = 30
}
variable "admin_username" {
  description = "(Optional) The Administrator login for this Azure MySQL Flexible Server. Required when create_mode is Default. Changing this forces a new Azure MySQL Flexible Server to be created. Defaults to `mysql_admin`."
  type        = string
  default     = "mysql_admin"
}
variable "admin_password" {
  description = "(Optional) The Password associated with the administrator_login for this Azure MySQL Flexible Server. Required when create_mode is Default."
  type        = string
  default     = null
  sensitive   = true
}
variable "mysql_version" {
  description = "(Optional) The version of this Azure MySQL Flexible Server to use. Possible values are `5.7`, and `8.0.21`. Changing this forces a new Azure MySQL Flexible Server to be created. Defaults to `8.0.21`."
  type        = string
  default     = "8.0.21"
}
variable "sku_name" {
  description = "(Optional) The SKU Name for this Azure MySQL Flexible Server. It should start with SKU tier B (Burstable), GP (General Purpose), MO (Memory Optimized) like B_Standard_B1s. Defaults to `B_Standard_B1ms`."
  type        = string
  default     = "B_Standard_B1ms"
}
variable "subnet_id" {
  description = "(Optional) The ID of the virtual network subnet to create this Azure MySQL Flexible Server. Changing this forces a new Azure MySQL Flexible Server to be created. Defaults to `Null`."
  type        = string
  default     = null
}
variable "zone" {
  description = "(Optional) Specifies the Availability Zone in which this Azure MySQL Flexible Server should be located. Possible values are `1`, `2` and `3`. Defaults to `Null`."
  type        = string
  default     = null
}
variable "mysql_options" {
  description = "(Optional) Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters. Defaults to `{}`."
  type        = map(string)
  default     = {}
}
variable "ssl_enforced" {
  description = "(Optional) Enforce SSL connection on MySQL provider and set require_secure_transport on Azure MySQL Flexible Server. Defaults to `true`."
  type        = bool
  default     = true
}
variable "databases" {
  description = "(Required) Map of databases with default collation and charset."
  type        = map(map(string))
}
variable "allowed_cidrs" {
  description = "(Optional) Map of authorized CIDRs. Defaults to `{}`."
  type        = map(string)
  default     = {}
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Tagging
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
