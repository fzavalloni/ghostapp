terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
data "azurerm_subscription" "this" {
}
resource "azurerm_role_assignment" "this" {
  for_each                         = var.assignments
  principal_id                     = each.value.principal_id
  role_definition_name             = each.value.role_definition_name
  scope                            = each.value.scope
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}
