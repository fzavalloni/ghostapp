#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Outputs
*/
#------------------------------------------------------------------------------------------------------------------------------------------
output "storage_account_id" {
  description = "The ID for this Azure Storage Account."
  value       = azurerm_storage_account.main.id
}
output "storage_account_name" {
  description = "The name for this Azure Storage Account."
  value       = azurerm_storage_account.main.name
}
output "primary_account_key" {
  description = "The primary key for this Azure Storage Account."
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}
output "primary_connection_string" {
  description = "The primary connection string for this Azure Storage Account. "
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}
output "secondary_account_key" {
  description = "The secondary key for this Azure Storage Account."
  value       = azurerm_storage_account.main.secondary_access_key
  sensitive   = true
}
output "secondary_connection_string" {
  description = "The secondary connection string for this Azure Storage Account. "
  value       = azurerm_storage_account.main.secondary_connection_string
  sensitive   = true
}
output "storage_account_identity" {
  description = "The identity for this Azure Storage Account."
  value       = azurerm_storage_account.main.identity
}
output "storage_account_properties" {
  description = "The properties for this Azure Storage Account."
  value       = azurerm_storage_account.main
}
output "storage_containers" {
  description = "The container names shares created in this Azure Storage Account."
  value       = azurerm_storage_container.this_container
}
output "storage_shares" {
  description = "The file share names created in this Azure Storage Account."
  value       = azurerm_storage_share.this_share
}
output "storage_tables" {
  description = "The table names created in this Azure Storage Account."
  value       = azurerm_storage_table.this_table
}
output "storage_account_network_rules" {
  description = "List of network rules assigned to this Azure Storage Account."
  value = try(
    one(azurerm_storage_account_network_rules.network_rules[*].enabled),
    azurerm_storage_account.main.network_rules[0],
  )
}
output "backup_policy_id" {
  description = "The ID of the Backup Policy Blob Storage, if created."
  value       = try(azurerm_data_protection_backup_policy_blob_storage.backup_policy[0].id, null)
}
output "backup_instance_id" {
  description = "The ID of the Backup Instance Blob Storage, if created."
  value       = try(azurerm_data_protection_backup_instance_blob_storage.backup_instance[0].id, null)
}
