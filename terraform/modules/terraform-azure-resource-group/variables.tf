variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Resource Group."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Resource Group."
  type        = string
  nullable    = false
}
variable "managed_by" {
  description = "(Optional) The ID of the resource or application that manages this Resource Group. Defaults to `null`"
  type        = string
  default     = null
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}



