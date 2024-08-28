#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Outputs
*/
#------------------------------------------------------------------------------------------------------------------------------------------
output "vnet_id" {
  description = "The ID of this newly created Azure Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}
output "vnet_name" {
  description = "The name of this newly created Azure Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}
output "vnet_location" {
  description = "The location of this newly created Azure Virtual Network."
  value       = azurerm_virtual_network.vnet.location
}
output "vnet_address_space" {
  description = "The address space of this newly created Azure Virtual Network."
  value       = azurerm_virtual_network.vnet.address_space
}
output "vnet_resource_group_name" {
  description = "The name of the resource group in which this Azure Virtual Network was created."
  value       = azurerm_virtual_network.vnet.resource_group_name
}
output "vnet_subnets" {
  description = "The IDs of subnets created inside this Azure Virtual Network."
  value       = azurerm_subnet.subnet.*.id
}
