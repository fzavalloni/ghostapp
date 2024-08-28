#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Outputs
*/
#------------------------------------------------------------------------------------------------------------------------------------------
output "id" {
  description = "The ID of this Azure KeyVault."
  value       = azurerm_key_vault.main.id
}
output "name" {
  description = "The name of this Azure KeyVault."
  value       = azurerm_key_vault.main.name
}
output "uri" {
  description = "The URI of this Azure KeyVault."
  value       = azurerm_key_vault.main.vault_uri
}
output "secrets" {
  description = "A mapping of secret names and URIs for this Azure KeyVault."
  value       = { for k, v in azurerm_key_vault_secret.main : v.name => v.id }
}
output "references" {
  description = "A mapping of Azure KeyVault references for App Service and Azure Functions."
  value = {
    for k, v in azurerm_key_vault_secret.main :
    v.name => format("@Microsoft.KeyVault(SecretUri=%s)", v.id)
  }
}
