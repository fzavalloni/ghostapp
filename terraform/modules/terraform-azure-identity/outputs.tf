output "id" {
  description = "The ID of this Azure Entra User Assigned Identity."
  value       = azurerm_user_assigned_identity.main.id
}
output "uai_client_id" {
  description = "The Client ID of this Azure Entra User Assigned Identity."
  value       = azurerm_user_assigned_identity.main.client_id
}
output "uai_principal_id" {
  description = "The Principal ID of this Azure Entra User Assigned Identity."
  value       = azurerm_user_assigned_identity.main.principal_id
}
