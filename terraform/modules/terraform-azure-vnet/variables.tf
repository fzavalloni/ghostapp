variable "virtualnet_name" {
  description = "(Required) Name of the vnet to create"
  type        = any  
}

variable "location" {
  description = "(Required) Location in which resource is going to be created"
  type        = any
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group to be imported."
  type        = string
}

variable "address_space" {
  description = "(Required) The address space that is used by the virtual network."
  type        = any
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "(Optional) The DNS servers to be used with vNet."
  type        = any
  default     = []
}

variable "tags" {
  description = "(Optional) The tags to associate with your network and subnets."
  type        = map(string)
  default     = {}
}

# For example
# SubNetId = NSGId
# subnet_assoc        = { 
#       5 = module.lata-brs-d-nsg-appsrv.network_security_group_id,
#       6 = module.lata-brs-d-nsg-appsrv.network_security_group_id
#   }

variable "subnet_assoc" {
  description = "(Optional) A map of subnet name to Network Security Group IDs"
  type        = map(string)
  default     = {}
}

variable "subnet_names" {
  type = list(object({
    name                                           = string
    address_prefixes                               = any
    enforce_private_link_endpoint_network_policies = bool
    service_endpoints                              = any
    delegation                                     = any
  }))
  default     = []
  description = "(Optional) List of subnets."
}