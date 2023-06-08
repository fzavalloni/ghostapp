variable "name" {
  description = "(Required) MySQL Server Name"
}

variable "resource_group_name" {
  description = "(Required) Resource Group Name"
}

variable "location" {
  description = "(Required) Azure Location"
}

variable "auto_grow_enable" {
  description = "(Optional) Should Storage Auto Grow be enabled?"
  type    = bool
  default = true
}

variable "storage_size_gb" {
  description = "(Optional) The max storage allowed for the MySQL Flexible Server. Possible values are between 20 and 16384"
  type    = number
  default = 32
}

variable "storage_iops" {
  description = "(Optional) The storage IOPS for the MySQL Flexible Server. Possible values are between 360 and 20000"
  default = 396
}

variable "backup_retention_days" {
  description = "(Optional) The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7"
  type    = number
  default = 30
}

variable "admin_username" {
  description = "(Optional) The Administrator login for the MySQL Flexible Server. Required when create_mode is Default. Changing this forces a new MySQL Flexible Server to be created."
  type        = string
  default     = "mysql_admin"
}

variable "admin_password" {
  description = "(Optional) The Password associated with the administrator_login for the MySQL Flexible Server. Required when create_mode is Default"
  type        = string  
}

variable "mysql_version" {
  description = "(Optional) The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new MySQL Flexible Server to be created."
  default     = "8.0.21"
}

variable "sku_name" {
  description = "(Optional) The SKU Name for the MySQL Flexible Server. It should start with SKU tier B (Burstable), GP (General Purpose), MO (Memory Optimized) like B_Standard_B1s."
  default     = "B_Standard_B1ms"
}

variable "subnet_id" {
  description = "(Optional) The ID of the virtual network subnet to create the MySQL Flexible Server. Changing this forces a new MySQL Flexible Server to be created."
  default = null
}

variable "zone" {
  description = "(Optional) Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3"  
  default = null
}

variable "mysql_options" {
  description = "(Optional) Map of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters."
  type        = map(string)
  default     = {}
}

variable "ssl_enforced" {
  description = "(Optional) Enforce SSL connection on MySQL provider and set require_secure_transport on MySQL Server"
  type        = bool
  default     = true
}

variable "databases" {
  description = "(Required) Map of databases with default collation and charset."
  type        = map(map(string))
}

variable "allowed_cidrs" {
  description = "(Optional) Map of authorized CIDRs"
  type        = map(string)
  default     = {}
}