module "akscluster01-diag" {
  source      = "../../../../modules/terraform-azure-diagnostic-settings"

  log_categories                 = ["kube-apiserver", "kube-audit-admin", "kube-scheduler", "cluster-autoscaler"]
  metric_categories              = [null]
  log_analytics_destination_type = "Dedicated"
  resource_id                    = module.akscluster01.aks_id

  logs_destinations_ids = [
    module.log01.log_analytics_workspace_id
  ]
}

module "akscluster01-app-gateway-containers-diag" {
  source      = "../../../../modules/terraform-azure-diagnostic-settings"

  log_categories                 = []
  metric_categories              = ["AllMetrics"]
  log_analytics_destination_type = "Dedicated"
  resource_id                    = module.akscluster01-app-gateway-containers.id

  logs_destinations_ids = [
    module.log01.log_analytics_workspace_id
  ]
}