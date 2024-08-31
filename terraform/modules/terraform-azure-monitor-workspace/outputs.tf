output "id" {
  description = "The ID of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.amw.id
}

output "name" {
  description = "The URL of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.amw.name
}

output "query_endpoint" {
  description = "The query endpoint of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.amw.query_endpoint
}

output "default_data_collection_endpoint_id" {
  description = "The default data collection rule ID of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.amw.default_data_collection_endpoint_id
}

output "default_data_collection_rule_id" {
  description = "The default data collection rule ID of the Azure Monitor Workspace."
  value       = azurerm_monitor_workspace.amw.default_data_collection_rule_id
}

output "clusters" {
  description = "The list of Kubernetes clusters to monitor."
  value       = var.clusters
}

output "private_endpoint_ips" {
  description = "The private endpoint to connect to the Azure Monitor Workspace."
  value       = length(azurerm_private_endpoint.amw) > 0 ? azurerm_private_endpoint.amw[0].custom_dns_configs[0].ip_addresses : null

}
output "private_endpoint_dns" {
  description = "The private endpoint DNS to connect to the Azure Monitor Workspace."
  value       = length(azurerm_private_endpoint.amw) > 0 ? azurerm_private_endpoint.amw[0].custom_dns_configs[0].fqdn : null
}

output "private_endpoint_id" {
  description = "The private endpoint ID to connect to the Azure Monitor Workspace."
  value       = length(azurerm_private_endpoint.amw) > 0 ? azurerm_private_endpoint.amw[0].id : null
}