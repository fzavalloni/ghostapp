
terraform {
  required_providers {
    azurerm = ">= 3.37.0"
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  #checkov:skip=CKV_AZURE_115:We cannot implement due backward compatibility
  #checkov:skip=CKV_AZURE_117:Not applicable
  #checkov:skip=CKV_AZURE_141:Not applicable because it is used in Azure Devops service principals
  #checkov:skip=CKV_AZURE_171:Not applicable
  #checkov:skip=CKV_AZURE_6:We have it, but it cannot be mandatory
  #checkov:skip=CKV_AZURE_4:We have it, but it cannot be mandatory
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.dns_prefix
  node_resource_group               = var.nodes_resource_group_name == null ? var.nodes_resource_group_name : var.nodes_resource_group_name
  kubernetes_version                = var.kubernetes_version
  sku_tier                          = var.sku_tier
  private_cluster_enabled           = var.private_cluster_enabled
  api_server_authorized_ip_ranges   = var.api_server_authorized_ip_ranges
  tags                              = var.tags
  local_account_disabled            = var.local_account_disabled
  http_application_routing_enabled  = var.enable_http_application_routing
  azure_policy_enabled              = var.enable_azure_policy

  // identity block
  // SystemAssigned is preferred so Azure takes care of the identity
  identity {
    type = var.identity_type == null ? "SystemAssigned" : var.identity_type
  }

  // nodepool block
  // The default nodepool is necessary for initial creation of the cluster
  // TODO: remove the default nodepool after creation https://www.terraform.io/docs/language/resources/provisioners/local-exec.html
  default_node_pool {
    name                = "default"
    node_count          = var.vm_count_default_nodepool
    vm_size             = var.vm_size_default_nodepool
    os_disk_size_gb     = 128
    vnet_subnet_id      = var.subnet_id_default_nodepool
    max_pods            = 250
    enable_auto_scaling = var.autoscaling_default_nodepool
    min_count           = var.autoscaling_min_count_default_nodepool
    max_count           = var.autoscaling_max_count_default_nodepool
  }

  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile != null ? [var.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = try(auto_scaler_profile.value.balance_similar_node_groups, null)
      expander                         = try(auto_scaler_profile.value.expander, null)
      max_graceful_termination_sec     = try(auto_scaler_profile.value.max_graceful_termination_sec, null)
      max_node_provisioning_time       = try(auto_scaler_profile.value.max_node_provisioning_time, null)
      max_unready_nodes                = try(auto_scaler_profile.value.max_unready_nodes, null)
      max_unready_percentage           = try(auto_scaler_profile.value.max_unready_percentage, null)
      new_pod_scale_up_delay           = try(auto_scaler_profile.value.new_pod_scale_up_delay, null)
      scale_down_delay_after_add       = try(auto_scaler_profile.value.scale_down_delay_after_add, null)
      scale_down_delay_after_delete    = try(auto_scaler_profile.value.scale_down_delay_after_delete, null)
      scale_down_delay_after_failure   = try(auto_scaler_profile.value.scale_down_delay_after_failure, null)
      scan_interval                    = try(auto_scaler_profile.value.scan_interval, null)
      scale_down_unneeded              = try(auto_scaler_profile.value.scale_down_unneeded, null)
      scale_down_unready               = try(auto_scaler_profile.value.scale_down_unready, null)
      scale_down_utilization_threshold = try(auto_scaler_profile.value.scale_down_utilization_threshold, null)
      empty_bulk_delete_max            = try(auto_scaler_profile.value.empty_bulk_delete_max, null)
      skip_nodes_with_local_storage    = try(auto_scaler_profile.value.skip_nodes_with_local_storage, null)
      skip_nodes_with_system_pods      = try(auto_scaler_profile.value.skip_nodes_with_system_pods, null)
    }
  }

  dynamic "linux_profile" {
    for_each = var.linux_profile != null ? [true] : []
    iterator = lp
    content {
      admin_username = var.linux_profile.username

      ssh_key {
        key_data = var.linux_profile.ssh_key
      }
    }
  }
  dynamic "windows_profile" {
    for_each = var.windows_profile != null ? [true] : []
    content {
      admin_username = var.windows_profile.username
      admin_password = var.windows_profile.password
    }
  }

  network_profile {
    docker_bridge_cidr = var.net_profile_docker_bridge_cidr
    dns_service_ip     = var.net_profile_dns_service_ip
    service_cidr       = var.net_profile_service_cidr
    load_balancer_sku  = var.net_profile_loadbalancer_sku
    network_plugin     = var.network_plugin # by default set to azure
    network_policy     = var.network_policy
    outbound_type      = var.net_profile_outbound_type
    pod_cidr           = var.net_profile_pod_cidr # only when using kubenet
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.rbac_enabled && var.rbac_aad_managed ? ["rbac"] : []
    content {
      managed                = true
      admin_group_object_ids = var.rbac_aad_admin_group_object_ids
    }
  }
  
  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider_enabled ? ["key_vault_secrets_provider"] : []

    content {
      secret_rotation_enabled  = var.secret_rotation_enabled
      secret_rotation_interval = var.secret_rotation_interval
    }
  }
  
  dynamic "oms_agent" {
    for_each = var.enable_log_analytics_workspace ? ["oms_agent"] : []

    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway_enabled ? ["ingress_application_gateway"] : []

    content {
      gateway_id   = var.ingress_application_gateway_id
      gateway_name = var.ingress_application_gateway_name
      subnet_cidr  = var.ingress_application_gateway_subnet_cidr
      subnet_id    = var.ingress_application_gateway_subnet_id
    }
  }

  dynamic "microsoft_defender" {
    for_each = var.microsoft_defender_enabled ? ["microsoft_defender"] : []

    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "pools" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each              = var.aks_additional_node_pools
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  name                  = each.value.name
  mode                  = each.value.mode
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  zones                 = each.value.zones
  max_pods              = 250
  os_disk_size_gb       = 128
  node_taints           = each.value.taints
  node_labels           = each.value.labels
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  vnet_subnet_id        = each.value.cluster_subnet_id
}
