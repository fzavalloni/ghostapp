output "id" {
  description = "The ID for this Azure DNS Zone."
  value       = try(azurerm_dns_zone.main.id, null)
}
output "name_servers" {
  description = "The name servers for this Azure DNS Zone."
  value       = try(azurerm_dns_zone.main.name_servers, null)
}
output "number_of_record_sets" {
  description = "The number of record sets for this Azure DNS Zone."
  value       = try(azurerm_dns_zone.main.number_of_record_sets, null)
}
