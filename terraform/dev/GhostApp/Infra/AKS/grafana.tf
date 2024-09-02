module "grafana01" {
  source              = "../../../../modules/terraform-azure-grafana"

  instance_name                 = "${var.environment-prefix}Grafana01"
  resource_group_name           = module.resource-group-01.name
  location                      = var.location
  sku                           = "Essential"
  public_network_access_enabled = true
  azure_monitor_workspace_integrations  =  [
    {
        resource_id = module.monitor-workspace01.id
    }
  ]
}