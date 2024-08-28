#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Main
*/
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Sets Providers and Versions
*/
#------------------------------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Module Logic
  - Resource block to create Azure Log Analytics Workspace.
  - Resource block to create Azure Log Analytics Solution.
    - Sub block to create a Container Insights Plan.
  - Resource block to create a Azure Log Analytics Query Pack.
/*
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure Log Analytics Workspace
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "main" {
  name                               = var.log_analytics_workspace_name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  sku                                = var.log_analytics_workspace_sku
  retention_in_days                  = var.log_retention_in_days
  daily_quota_gb                     = var.log_daily_quota_gb
  reservation_capacity_in_gb_per_day = var.log_reservation_capacity_in_gb_per_day
  tags                               = var.tags
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure Log Analytics Solution
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_solution" "main" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name
  tags                  = var.tags

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure Log Analytics Query Pack
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack" "main" {
  count               = var.create_log_analytics_query_pack ? 1 : 0
  name                = var.query_pack_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
