terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.22"
    }
  }
}
data "azurerm_monitor_diagnostic_categories" "main" {
  count       = local.enabled ? 1 : 0
  resource_id = var.resource_id
}
data "azurecaf_name" "diag" {
  name          = "default"
  resource_type = "azurerm_monitor_diagnostic_setting"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([local.name_suffix])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
resource "azurerm_monitor_diagnostic_setting" "main" {
  count                          = local.enabled ? 1 : 0
  name                           = local.diag_name
  target_resource_id             = var.resource_id
  storage_account_id             = local.storage_id
  log_analytics_workspace_id     = local.log_analytics_id
  log_analytics_destination_type = local.log_analytics_destination_type
  eventhub_authorization_rule_id = local.eventhub_authorization_rule_id
  eventhub_name                  = local.eventhub_name

  dynamic "enabled_log" {
    for_each = local.log_categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = local.metrics

    content {
      category = metric.key
      enabled  = metric.value.enabled
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
