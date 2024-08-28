module "log01" {
  source                       = "../../../modules/terraform-azure-loganalytics"
  log_analytics_workspace_name = "${var.environment-prefix}LOG01"
  location                     = var.location
  resource_group_name          = module.resource-group-01.name
  query_pack_name              = null

  depends_on = [
    module.resource-group-01
  ]
}