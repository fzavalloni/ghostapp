terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
resource "azurerm_mysql_flexible_server" "this" {
  #checkov:skip=CKV_AZURE_94:Ensure My SQL server enables geo-redundant backups. Not applicable
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  backup_retention_days  = var.backup_retention_days
  sku_name               = var.sku_name
  version                = var.mysql_version
  zone                   = var.zone
  delegated_subnet_id    = var.subnet_id
  tags                   = var.tags

  storage {
    auto_grow_enabled = var.auto_grow_enable
    iops              = var.storage_iops
    size_gb           = var.storage_size_gb
  }
}
resource "azurerm_mysql_flexible_server_configuration" "this" {
  for_each            = merge(local.default_mysql_options, var.mysql_options)
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  value               = each.value

  depends_on = [
    azurerm_mysql_flexible_server.this
  ]
}
resource "azurerm_mysql_flexible_database" "this" {
  for_each            = var.databases
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  charset             = lookup(each.value, "charset", "utf8")
  collation           = lookup(each.value, "collation", "utf8_general_ci")

  depends_on = [
    azurerm_mysql_flexible_server.this
  ]
}
resource "azurerm_mysql_flexible_server_firewall_rule" "this" {
  for_each            = var.allowed_cidrs
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, 0)

  depends_on = [
    azurerm_mysql_flexible_server.this
  ]
}
