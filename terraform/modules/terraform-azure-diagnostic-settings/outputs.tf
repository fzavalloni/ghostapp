output "diagnostic_settings_id" {
  description = "The ID of this Azure Diagnostic Settings."
  value       = try(azurerm_monitor_diagnostic_setting.main[0].id, null)
}
