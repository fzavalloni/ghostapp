terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.uai_name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "identity" {
  count               = var.enable_identity_credential ? 1 : 0
  name                = "${var.uai_name}-Federation-Id"
  resource_group_name = var.resource_group_name
  audience            = var.federated_identity_audience
  issuer              = var.federated_identity_issuer
  parent_id           = azurerm_user_assigned_identity.main.id
  subject             = var.federated_identity_subject
}
