variable "display_name" {
  description = "(Required) The Name of the group."
  type        = string
}
variable "description" {
  description = "(Required) Descritpion of the group."
  type        = string
}

variable "members" {
  description = "(Required) Members of this group."
  type        = any
  default     = []
}

variable "security_enabled" {
  type        = bool
  description = "(Optional) Whether the group is a security group for controlling access to in-app resources. At least one of security_enabled or mail_enabled must be specified"
  default     = true
}