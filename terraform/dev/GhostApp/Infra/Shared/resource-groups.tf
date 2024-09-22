module "shared-resource-group" {
  source              = "../../../../modules/terraform-azure-resource-group"
  resource_group_name = "${var.environment-prefix}Share-RSG"
  location            = var.location
}