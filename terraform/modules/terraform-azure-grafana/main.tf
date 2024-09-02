resource "azurerm_dashboard_grafana" "this" {
  name                              = var.instance_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  sku                               = var.sku
  api_key_enabled                   = var.api_key_enabled
  deterministic_outbound_ip_enabled = var.deterministic_outbound_ip_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  zone_redundancy_enabled           = var.zone_redundancy_enabled
  tags                              = var.tags
  grafana_major_version             = var.grafana_major_version

  identity {
    type = var.identity_type == null ? "SystemAssigned" : var.identity_type
  }

  dynamic "azure_monitor_workspace_integrations" {
    for_each = var.azure_monitor_workspace_integrations
    content {
        resource_id = azure_monitor_workspace_integrations.value.resource_id
    }
  }
}
