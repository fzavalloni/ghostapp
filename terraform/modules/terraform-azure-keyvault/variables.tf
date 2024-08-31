variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure KeyVault."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure KeyVault."
  type        = string
  nullable    = false
}
variable "name" {
  description = "(Required) The name of this Azure KeyVault."
  type        = string
  nullable    = false
}
variable "sku" {
  description = "(Optional) The SKU used for this Azure KeyVault. The options are: `standard`, `premium`. Defaults to `standard`."
  type        = string
  default     = "standard"
}
variable "enabled_for_deployment" {
  description = "(Optional) Allow Virtual Machines to retrieve certificates stored as secrets from this Azure KeyVault. Defaults to `false`."
  type        = bool
  default     = false
}
variable "network_acls" {
  description = "(Optional) Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. Set to `null` to disable. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more information."
  type        = any
  default     = null
}
variable "enabled_for_disk_encryption" {
  description = "(Optional) Allow Disk Encryption to retrieve secrets from the vault and unwrap keys. Defaults to `false`."
  type        = bool
  default     = false
}
variable "enabled_for_template_deployment" {
  description = "(Optional) Allow Resource Manager to retrieve secrets from the Azure KeyVault. Defaults to `false`."
  type        = bool
  default     = false
}
variable "access_policies" {
  description = "(Optional) List of access policies for the Azure KeyVault. Defaults to `[]`."
  type        = any
  default     = []
}
variable "secrets" {
  description = "(Optional) A map of secrets for the Azure KeyVault. Defaults to `{}`."
  type        = map(string)
  default     = {}
}
variable "purge_protection_enabled" {
  description = "(Optional) Enable purge protection. Defaults to `true`."
  type        = bool
  default     = true
}
variable "enable_rbac_authorization" {
  description = "(Optional) Enable RBAC authorization. Defaults to `false`."
  type        = bool
  default     = false
}
variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this Azure KeyVault. Defaults to `false`."
  type        = bool
  default     = false
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
