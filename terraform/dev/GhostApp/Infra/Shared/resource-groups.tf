module "shared-resource-group" {
  source              = "../../../../modules/terraform-azure-resource-group"
  resource_group_name = "${var.environment-prefix}Shared-RSG"
  location            = var.location
}