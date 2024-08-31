resource "azurerm_resource_provider_registration" "default" {
  name = "Microsoft.Dashboard"
}

resource "azurerm_dashboard_grafana" "default" {
  name                              = var.instance_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  sku                               = "Standard"
  api_key_enabled                   = var.api_key_enabled
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = var.public_network_access_enabled

  grafana_major_version = var.grafana_major_version

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = var.monitor_workspace.id
  }

  tags = var.tags

  depends_on = [azurerm_resource_provider_registration.default]
}

# This role binding needs to be set to the whole subsription. Maybe this is a too broad scope for grafana
resource "azurerm_role_assignment" "grafana" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.default.identity[0].principal_id
}

# Add role assignment to Grafana so an admin user can log in
resource "azurerm_role_assignment" "grafana_admin" {
  scope                = azurerm_dashboard_grafana.default.id
  role_definition_name = "Grafana Admin"
  principal_id         = var.grafana_admin_object_id
}

provider "grafana" {
  url  = azurerm_dashboard_grafana.default.endpoint
  auth = var.grafana_auth_token
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  name = var.monitor_workspace.name

  access_mode = "proxy"
  url         = var.monitor_workspace.query_endpoint

  json_data_encoded = jsonencode({
    azureAuthType = "msi"
    azureCredentials = {
      authType = "msi",
    }
    httpMethod   = "POST"
    timeInterval = "30s"
    manageAlerts = false
  })

  depends_on = [azurerm_dashboard_grafana.default]
}