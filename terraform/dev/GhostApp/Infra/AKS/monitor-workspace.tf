module "monitor-workspace01" {
  source              = "../../../../modules/terraform-azure-monitor-workspace"

  monitor_workspace_name  = "${var.environment-prefix}Mon01"
  resource_group_name     = module.resource-group-01.name
  resource_group_location = var.location

  clusters = {
    aks01 = module.akscluster01.aks_id
  }
}