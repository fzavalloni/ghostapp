output "id" {
  description = "The ID of this Azure Application Load Balancer."
  value       = azurerm_application_load_balancer.main.id
}
output "primary_configuration_endpoint" {
  description = "The primary endpoint ID of this Azure Application Load Balancer."
  value       = azurerm_application_load_balancer.main.primary_configuration_endpoint
}
output "frontend_name" {
  description = "TThe name which should be used for this Application Gateway for Containers Frontend."
  value       = var.frontend_name
}
output "frontend_fqdn" {
  description = "The Fully Qualified Domain Name of the DNS record associated to an Application Gateway for Containers Frontend."
  value       = azurerm_application_load_balancer_frontend.main.fully_qualified_domain_name
}
output "frontend_id" {
  description = "The ID of the Application Gateway for Containers Frontend."
  value       = azurerm_application_load_balancer_frontend.main.id
}