variable "name" {
  description = "(Required) DNS Zone Name"
}
variable "rg_name" {
  description = "(Required) Resource Group Name"
}

variable "soa_records" {
  description = "(Optional) SOA DNS entries"
  type    = any
  default = []
}

variable "a_records" {
  description = "(Optional) A DNS entries"
  type    = any
  default = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
}