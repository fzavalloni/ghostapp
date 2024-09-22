module "resource-group-01" {
  source              = "../../../../modules/terraform-azure-resource-group"
  resource_group_name = "${var.environment-prefix}RSG"
  location            = var.location
}
module "backup-resource-group" {
  source              = "../../../../modules/terraform-azure-resource-group"
  resource_group_name = "${var.environment-prefix}Backup"
  location            = var.location
}