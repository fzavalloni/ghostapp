variable "monitor_workspace_name" {
  type        = string
  description = "Name of the Azure Monitor workspace."
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "clusters" {
  description = "List of Kubernetes clusters to monitor."
  type        = map(string)
}

variable "private_endpoint" {
  description = "Private endpoint to connect to the Azure Monitor workspace."
  type = object({
    subnet_id         = optional(string)
    subresource_names = optional(list(string))
  })
  default = {}
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access to the Azure Monitor workspace."
  type        = bool
  default     = true
}