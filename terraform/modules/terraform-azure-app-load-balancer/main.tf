terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
resource "azurerm_application_load_balancer" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_application_load_balancer_frontend" "main" {
  name                         = var.frontend_name
  application_load_balancer_id = azurerm_application_load_balancer.main.id
}

resource "azurerm_application_load_balancer_subnet_association" "main" {
  for_each                     = var.subnet_associations
  name                         = each.value.name
  application_load_balancer_id = azurerm_application_load_balancer.main.id
  subnet_id                    = each.value.subnet_id
}