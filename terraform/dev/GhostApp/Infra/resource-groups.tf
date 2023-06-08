module "resource-group-01" {
  source        = "../../../modules/terraform-azure-resource-group"
  rg_name       = "${var.environment-prefix}RSG"
  location      = var.location
}