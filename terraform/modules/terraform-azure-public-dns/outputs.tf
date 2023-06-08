output "id" {
  value = azurerm_dns_zone.main.id
}

output "name_servers" {
  value = azurerm_dns_zone.main.name_servers
}

output "number_of_record_sets" {
  value = azurerm_dns_zone.main.number_of_record_sets
}