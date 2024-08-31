module "shared-resource-group" {
  source        = "../../../../modules/terraform-azure-resource-group"
  rg_name       = "${var.environment-prefix}Shared-RSG"
  location      = var.location
}