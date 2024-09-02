terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
resource "azurerm_kubernetes_cluster" "main" {
  #checkov:skip=CKV_AZURE_115: PrivateCluster: Not applicable: Unable to implement. Backwards Compatibility.
  #checkov:skip=CKV_AZURE_117: DiskEnc:      : Not applicable. Unable to enforce.   DiskEnc is managed by Azure.
  #checkov:skip=CKV_AZURE_141: LocalAdmin    : Not applicable. Unable to implement. Used in AzureDevOps.
  #checkov:skip=CKV_AZURE_171: UpgradeChl    : Not applicable. Unable to implement. Business requires manual.
  #checkov:skip=CKV_AZURE_6:   AuthorisedRge : Not applicable. Unable to implement. Backwards Compatibility.
  #checkov:skip=CKV_AZURE_4:   Logging       : Not applicable. Unable to enforce.   Container Insights, and diagnostics.tf to Log Analytics.
  #checkov:skip=CKV_AZURE_170: PaidSKU       : Not applicable. Unable to implement. Mix of Paid and Free SKU clusters.
  name                             = var.cluster_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  kubernetes_version               = var.kubernetes_version
  sku_tier                         = var.sku_tier
  dns_prefix                       = var.dns_prefix
  dns_prefix_private_cluster       = var.private_cluster_dns_prefix
  automatic_channel_upgrade        = var.automatic_channel_upgrade
  azure_policy_enabled             = var.enable_azure_policy
  cost_analysis_enabled            = var.cost_analysis_enabled
  http_application_routing_enabled = var.enable_http_application_routing
  image_cleaner_enabled            = var.image_cleaner_enabled
  image_cleaner_interval_hours     = var.image_cleaner_interval_hours
  local_account_disabled           = var.local_account_disabled
  node_os_channel_upgrade          = var.node_os_channel_upgrade
  node_resource_group              = var.nodes_resource_group_name == null ? var.nodes_resource_group_name : var.nodes_resource_group_name
  oidc_issuer_enabled              = var.oidc_issuer_enabled
  open_service_mesh_enabled        = var.service_mesh_envoy_enabled // Enables Open Service Mesh for Envoy https://learn.microsoft.com/en-us/azure/aks/open-service-mesh-about
  private_cluster_enabled          = var.private_cluster_enabled
  workload_identity_enabled        = var.workload_identity_enabled
  run_command_enabled              = var.run_command_enabled
  tags                             = var.tags

  identity {
    type = var.identity_type == null ? "SystemAssigned" : var.identity_type
  }

  dynamic "api_server_access_profile" {
    for_each = length(var.api_authorized_ip_ranges) > 0 ? [1] : []

    content {
      authorized_ip_ranges     = var.api_authorized_ip_ranges
      subnet_id                = var.api_subnet_id
      vnet_integration_enabled = var.api_vnet_integration_enabled
    }
  }

  default_node_pool {
    name                          = var.default_nodepool_name
    node_count                    = var.default_nodepool_autoscaling ? null : var.default_nodepool_vm_count
    vm_size                       = var.default_nodepool_vm_size
    capacity_reservation_group_id = var.default_nodepool_vm_capacity_reservation_group_id
    os_sku                        = var.default_nodepool_vm_os_sku
    os_disk_type                  = var.default_nodepool_vm_os_disk_type
    os_disk_size_gb               = var.default_nodepool_vm_os_disk_size
    type                          = var.default_nodepool_type
    orchestrator_version          = var.nodepool_orchestrator_version
    vnet_subnet_id                = var.default_nodepool_subnet_id
    zones                         = var.default_nodepool_zones
    max_pods                      = var.default_nodepool_max_pods
    enable_auto_scaling           = var.default_nodepool_autoscaling
    min_count                     = var.default_nodepool_autoscaling_min_count
    max_count                     = var.default_nodepool_autoscaling_max_count
    scale_down_mode               = var.default_nodepool_scale_down_mode
    only_critical_addons_enabled  = var.default_nodepool_only_critical_addons_enabled
    node_labels                   = var.default_nodepool_node_labels
    enable_host_encryption        = var.default_nodepool_enable_host_encryption
    enable_node_public_ip         = var.default_nodepool_enable_node_public_ip
    node_public_ip_prefix_id      = var.default_nodepool_public_ip_prefix
    ultra_ssd_enabled             = var.default_nodepool_ultra_ssd_enabled
    temporary_name_for_rotation   = var.default_nodepool_name_for_rotation
    workload_runtime              = var.default_nodepool_workload_runtime
    fips_enabled                  = var.default_nodepool_fips_enabled
    tags                          = var.tags

    upgrade_settings {
      max_surge                     = var.node_max_surge
      drain_timeout_in_minutes      = var.drain_timeout_in_minutes
      node_soak_duration_in_minutes = var.node_soak_duration_in_minutes
    }
  }

  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics != null ? ["monitor_metrics"] : []

    content {
      annotations_allowed = var.monitor_metrics.annotations_allowed
      labels_allowed      = var.monitor_metrics.labels_allowed
    }
  }

  dynamic "storage_profile" {
    for_each = var.storage_profile_enabled ? ["storage_profile"] : []

    content {
      blob_driver_enabled         = var.storage_profile_blob_driver_enabled
      disk_driver_enabled         = var.storage_profile_disk_driver_enabled
      disk_driver_version         = var.storage_profile_disk_driver_version
      file_driver_enabled         = var.storage_profile_file_driver_enabled
      snapshot_controller_enabled = var.storage_profile_snapshot_controller_enabled
    }
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
    network_mode        = var.net_mode
    network_plugin      = var.net_plugin
    network_plugin_mode = var.net_plugin_mode
    network_policy      = var.net_policy
    network_data_plane  = var.net_data_plane
    dns_service_ip      = var.net_profile_dns_service_ip
    service_cidr        = var.net_profile_service_cidr
    pod_cidr            = var.net_profile_pod_cidr
    ebpf_data_plane     = var.net_dataplane
    ip_versions         = var.net_ip_versions
    outbound_type       = var.net_profile_outbound_type
    load_balancer_sku   = var.net_profile_loadbalancer_sku

    dynamic "load_balancer_profile" {
      for_each = var.load_balancer_profile_enabled ? [1] : []
      content {
        managed_outbound_ip_count   = var.net_azlb_managed_outbound_ipv4_count
        managed_outbound_ipv6_count = var.net_azlb_managed_outbound_ipv6_count
        idle_timeout_in_minutes     = var.net_azlb_idle_timeout_in_minutes
        outbound_ports_allocated    = var.net_azlb_ports_allocated_per_instance
      }
    }
    dynamic "nat_gateway_profile" {
      for_each = var.nat_gateway_profile_enabled ? [1] : []
      content {
        managed_outbound_ip_count = var.net_aznatgw_outbound_ip_count
        idle_timeout_in_minutes   = var.net_aznatgw_idle_timeout_in_minutes
      }
    }
  }

  dynamic "service_mesh_profile" {
    for_each = var.service_mesh_istio_profile_enabled ? ["service_mesh_profile"] : []

    content {
      mode = var.service_mesh_istio_profile.mode
    }
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
      log_analytics_workspace_id      = var.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = var.msi_auth_for_monitoring_enabled
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

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? ["maintenance_window"] : []
    content {
      dynamic "allowed" {
        for_each = var.maintenance_window.allowed
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = var.maintenance_window.not_allowed
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.maintenance_window_auto_upgrade != null ? ["maintenance_window_auto_upgrade"] : []
    content {
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      duration     = maintenance_window_auto_upgrade.value.duration
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      week_index   = maintenance_window_auto_upgrade.value.week_index
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
      start_date   = maintenance_window_auto_upgrade.value.start_date
      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed == null ? [] : maintenance_window_auto_upgrade.value.not_allowed
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.maintenance_window_node_os == null ? [] : [var.maintenance_window_node_os]
    content {
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      duration     = maintenance_window_node_os.value.duration
      day_of_week  = maintenance_window_node_os.value.day_of_week
      day_of_month = maintenance_window_node_os.value.day_of_month
      week_index   = maintenance_window_node_os.value.week_index
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      start_date   = maintenance_window_node_os.value.start_date
      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed == null ? [] : maintenance_window_node_os.value.not_allowed
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
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
  orchestrator_version  = var.nodepool_orchestrator_version
  node_taints           = each.value.taints
  node_labels           = each.value.labels
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  vnet_subnet_id        = each.value.cluster_subnet_id
  tags                  = var.tags
  upgrade_settings {
    max_surge                     = var.node_max_surge
    drain_timeout_in_minutes      = var.drain_timeout_in_minutes
    node_soak_duration_in_minutes = var.node_soak_duration_in_minutes
  }
}
