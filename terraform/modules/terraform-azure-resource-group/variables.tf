variable "location" {
  type        = string
  description = "The location to deploy the resource group in to."
}

variable "tags" {
  type        = map(string)
  description = "List of tags to assign to the resource group."
  default     = {}
}

variable "rg_name" {
  description = "Default RG name "
  default     = "aname"
  type        = string
}
