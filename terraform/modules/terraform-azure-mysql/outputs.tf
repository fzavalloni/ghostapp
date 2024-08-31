output "id" {
  description = "The ID of this Azure MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.this.id
}
output "name" {
  description = "The name of this Azure MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.this.name
}
output "details" {
  description = "The details for this Azure MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.this
}
