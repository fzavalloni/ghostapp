terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
resource "azurerm_resource_group" "rg" {
  name       = var.resource_group_name
  location   = var.location
  managed_by = var.managed_by
  tags       = var.tags
}
