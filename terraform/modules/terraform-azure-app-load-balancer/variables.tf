variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Application Load Balancer."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Application Load Balancer"
  type        = string
  nullable    = false
}
variable "name" {
  description = "(Required) Specifies the name of this Azure Application Load Balancer. Changing this forces a new User Assigned Identity to be created."
  type        = string
  nullable    = false  
}
variable "frontend_name" {
  description = "(Required) The name which should be used for this Application Gateway for Containers Frontend. Changing this forces a new resource to be created."
  type        = string
  nullable    = false  
}
variable "subnet_associations" {
  description = "(Optional) Specifies the Subnet Associations"
  type = map(object({
    name      = string
    subnet_id = string
  }))
  default = {}
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}