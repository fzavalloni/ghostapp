output "id" {
  description = "Resource Group id"
  value       = azurerm_resource_group.rg.id
}

output "name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.rg.name
}

output "rg_location" {
  description = "Resource Group location"
  value       = azurerm_resource_group.rg.location
}