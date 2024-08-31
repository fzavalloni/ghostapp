variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Virtual Network."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Virtual Network."
  type        = string
  nullable    = false
}
variable "virtualnet_name" {
  description = "(Required) Name of this Azure Virtual Network to create."
  type        = any
  nullable    = false
}
variable "address_space" {
  description = "(Required) The address space that is used by this Azure Virtual Network."
  type        = any
  nullable    = false
}
variable "dns_servers" {
  description = "(Optional) The DNS servers to be used with this Azure Virtual Network. Default is `[]`."
  type        = any
  default     = []
}
variable "subnet_assoc" {
  description = <<-EOT
  (Optional) A map of subnet IDs to Network Security Group IDs for association. Defaults to `{}`.

  Inputs

  ```hcl
  subnet_assoc = {
    5 = module.lata-brs-d-nsg-appsrv.network_security_group_id,
    6 = module.lata-brs-d-nsg-appsrv.network_security_group_id
  }
  ```
  EOT
  type        = map(string)
  default     = {}
}
variable "subnet_names" {
  description = "(Optional) List of subnets to create with this Azure Virtual Network"
  type = list(object({
    name                              = string
    address_prefixes                  = any
    private_endpoint_network_policies = string
    service_endpoints                 = any
    delegation                        = any
  }))
  default = []
}
variable "ddos_protection_plan_id" {
  description = "(Required) ID of the Azure DDOS protection plan."
  type        = string
  default     = null
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
