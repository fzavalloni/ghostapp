#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Main
*/
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Sets Providers and Versions
*/
#------------------------------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = ">= 3.69.0"
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Module Logic
  - Resource block to create Azure Virtual Network.
  - Resource block to create Azure Virtual Network Subnet.
  - Resource block to create Azure Virtual Network Security Group Association.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure Virtual Network
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtualnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [""] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }

  }


}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure Virtual Network Subnet
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_subnet" "subnet" {
  count                             = length(var.subnet_names)
  name                              = var.subnet_names[count.index].name
  resource_group_name               = var.resource_group_name
  address_prefixes                  = var.subnet_names[count.index].address_prefixes
  virtual_network_name              = azurerm_virtual_network.vnet.name
  private_endpoint_network_policies = var.subnet_names[count.index].private_endpoint_network_policies
  service_endpoints                 = var.subnet_names[count.index].service_endpoints
  dynamic "delegation" {
    for_each = var.subnet_names[count.index].delegation
    content {
      name = delegation.key
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure Virtual Network Security Group Association
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.subnet_assoc
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value
}
