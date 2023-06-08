module "mysql01" {
  source                = "../../../modules/terraform-azure-mysql"
  
  name                  = "mysql-ghost"
  location              = var.location
  resource_group_name   = module.resource-group-01.name
  zone                  = 1
  sku_name              = "B_Standard_B1ms"
  backup_retention_days = 1
  admin_username        = "ghost"
  admin_password        = var.ghost_app_password
  mysql_version         = "5.7"
  ssl_enforced          = false
  subnet_id             = module.vnet01.vnet_subnets[6]

  databases = {
    "ghost_db" = {
      "charset"   = "utf8"
      "collation" = "utf8_general_ci"
    }
  }  
}