output "id" {
  description = "The ID of this Azure Resource Group."
  value       = azurerm_resource_group.rg.id
}
output "name" {
  description = "The name of this Azure Resource Group."
  value       = azurerm_resource_group.rg.name
}
output "rg_location" {
  description = "The location of this Azure Resource Group."
  value       = azurerm_resource_group.rg.location
}
