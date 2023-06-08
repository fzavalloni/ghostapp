terraform {
  required_providers {
    azurerm = ">= 2.95.0"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtualnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags

}

resource "azurerm_subnet" "subnet" {
  count                                          = length(var.subnet_names)
  name                                           = var.subnet_names[count.index].name
  resource_group_name                            = var.resource_group_name
  address_prefixes                               = var.subnet_names[count.index].address_prefixes
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = var.subnet_names[count.index].enforce_private_link_endpoint_network_policies
  service_endpoints                              = var.subnet_names[count.index].service_endpoints
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

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.subnet_assoc
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value
}
