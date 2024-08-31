output "log_analytics_workspace_id" {
  description = "The ID of this Azure Log Analytics Workspace."
  value       = try(azurerm_log_analytics_workspace.main.id, null)
}
output "log_analytics_workspace_primary_shared_key" {
  description = "The primary shared key for this Azure Log Analytics Workspace."
  value       = try(azurerm_log_analytics_workspace.main.primary_shared_key, null)
  sensitive   = true
}
output "log_analytics_query_pack_id" {
  description = "The ID of the Log Analytics Query Pack."
  value       = try(azurerm_log_analytics_query_pack.main[0].id, null)
}
