# module "grafana01" {
#   source              = "../../../../modules/terraform-azure-grafana"

#   instance_name           = "${var.environment-prefix}Grafana01"
#   resource_group_name     = module.resource-group-01.name
#   location                = var.location
#   grafana_admin_object_id = "8b4d4451-2098-4c72-bc17-b09bd710ec65"
#   subscription_id         = var.subs_id
#   monitor_workspace = {
#     name                                = "monitor-workspace"
#     id                                  = "00000000-0000-0000-0000-000000000000"
#     query_endpoint                      = "https://monitor-workspace-api.azuremonitor.com"
#     default_data_collection_endpoint_id = "00000000-0000-0000-0000-000000000000"
#     default_data_collection_rule_id     = "00000000-0000-0000-0000-000000000000"
#   }
# }