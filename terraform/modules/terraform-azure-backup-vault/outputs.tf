#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Outputs
*/
#------------------------------------------------------------------------------------------------------------------------------------------
output "backup_vault_id" {
  value       = try(azurerm_data_protection_backup_vault.this.id, null)
  description = "The ID of this Azure Data Protection Backup Vault."
}
output "backup_vault_name" {
  value       = try(azurerm_data_protection_backup_vault.this.name, null)
  description = "The name of this Azure Data Protection Backup Vault."
}
output "backup_vault_resource_group_name" {
  value       = try(azurerm_data_protection_backup_vault.this.resource_group_name, null)
  description = "The name of the resource group which contains this Azure Data Protection Backup Vault."
}
output "backup_vault_location" {
  value       = try(azurerm_data_protection_backup_vault.this.location, null)
  description = "The location of this Azure Data Protection Backup Vault."
}
output "identity" {
  value       = try(azurerm_data_protection_backup_vault.this.identity[0].principal_id, null)
  description = "The ID of the system assigned credential for this Azure Data Protection Backup Vault."
}
