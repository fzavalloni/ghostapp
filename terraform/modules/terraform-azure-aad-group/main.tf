terraform {
  required_providers {
    azurerm = ">= 2.95.0"
  }
}

resource "azuread_group" "this" {
  display_name     = var.display_name
  description      = var.description
  members          = var.members
  security_enabled = var.security_enabled
}