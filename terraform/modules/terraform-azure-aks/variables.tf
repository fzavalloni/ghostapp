variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Kubernetes Service."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Kubernetes Service."
  type        = string
  nullable    = false
}
variable "cluster_name" {
  description = "(Required) The name of the cluster. If there is no prefix, this name will be used for the cluster."
  type        = string
  nullable    = false
}
variable "nodes_resource_group_name" {
  description = "(Required) Name for the resource group for the cluster resources."
  type        = string
  nullable    = false
}
variable "kubernetes_version" {
  description = "(Optional) Kubernetes Version - az aks get-versions --location westeurope --output table. Defaults to `1.26.6`."
  type        = string
  default     = "1.26.6"
}
variable "sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`. Defaults to `Paid`."
  type        = string
  default     = "Paid"
}
variable "run_command_enabled" {
  description = "(Optional) Whether to enable run command for the cluster or not. Defaults to `Null`."
  type        = bool
  default     = null
}
variable "automatic_channel_upgrade" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are `patch`, `rapid`, `node-image` and `stable`. Omitting this field sets this value to none. Defaults to `Null`."
  type        = string
  default     = null
}
variable "node_os_channel_upgrade" {
  description = <<EOT
  (Optional) The upgrade channel for this Kubernetes Cluster Nodes' OS Image. Possible values are `Unmanaged`, `SecurityPatch`, `NodeImage` and `None`. Defaults to `Null`.

  Notices
  1. `node_os_channel_upgrade` must be set to `NodeImage` if `automatic_channel_upgrade` has been set to `node-image`.

  EOT
  type        = string
  default     = null
}
variable "image_cleaner_enabled" {
  description = "(Optional) Specifies whether Image Cleaner is enabled. Defaults to `Null`."
  type        = bool
  default     = null
}
variable "image_cleaner_interval_hours" {
  description = "(Optional) Specifies the interval in hours when images should be cleaned up. Defaults to `Null`."
  type        = number
  default     = null
}
variable "private_cluster_enabled" {
  description = "(Optional) If true cluster API server will be exposed only on internal IP address and available only in cluster vnet. Defaults to `false`."
  type        = bool
  default     = false
}
variable "private_cluster_dns_prefix" {
  description = "(Optional) Specifies the DNS prefix to use with private clusters. Changing this forces a new resource to be created. Defaults to `Null`."
  type        = string
  default     = null
}
variable "identity_type" {
  description = "(Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, a `user_assigned_identity_id` must be set as well. Defaults to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}
variable "rbac_enabled" {
  description = "(Optional) Enable Role Based Access Control. Defaults to `true`."
  type        = bool
  default     = true
}
variable "rbac_aad_managed" {
  description = "(Optional) Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration. Defaults to `true`."
  type        = bool
  default     = true
}
variable "rbac_aad_admin_group_object_ids" {
  description = "(Optional) Object ID of groups with admin access. Defaults to `Null`."
  type        = list(string)
  default     = null
}
variable "oidc_issuer_enabled" {
  description = "(Optional) Enable or Disable the OIDC issuer URL. Defaults to false."
  type        = bool
  default     = false
}
variable "workload_identity_enabled" {
  description = "(Optional) Specifies whether Azure AD Workload Identity should be enabled for the Cluster. Defaults to false."
  type        = bool
  default     = false
}
variable "api_authorized_ip_ranges" {
  description = "(Optional) Set of authorized IP ranges to allow access to the API server. Defaults to `Null`."
  type        = list(string)
  default     = []
}
variable "api_subnet_id" {
  description = "(Optional) The ID of the Subnet where the API server endpoint is delegated to. Defaults to `Null`."
  type        = string
  default     = null
}
variable "api_vnet_integration_enabled" {
  description = "(Optional) Should API Server VNet Integration be enabled? Defaults  to `false`."
  type        = bool
  default     = false
}
variable "nodepool_orchestrator_version" {
  description = <<EOT
  "(Optional) Version of Kubernetes used for Default and Additional Node Pools. If not specified, the default node pool will be created with the version specified by `kubernetes_version`. If both are unspecified, the latest recommended version will be used at provisioning time (but won't auto-upgrade).
  AKS does not require an exact patch version to be specified, minor version aliases such as 1.22 are also supported. The minor version's latest GA patch is automatically chosen in that case. Defaults to `Null`."
  EOT
  type        = string
  default     = null
}
variable "default_nodepool_name" {
  description = " (Required) The name which should be used for the default Kubernetes Node Pool. Changing this forces a new resource to be created. Defaults to `default`."
  type        = string
  default     = "default"
}
variable "default_nodepool_vm_size" {
  description = "(Optional) Azure VM node size e.g. Standard_D2s_v3 or Standard_B4ms - az vm list-sizes --location westeurope. Defaults to `Standard_B2ms`."
  type        = string
  default     = "Standard_B2ms"
}
variable "default_nodepool_vm_capacity_reservation_group_id" {
  description = "(Optional) Specifies the ID of the Capacity Reservation Group within which this AKS Cluster should be created. Changing this forces a new resource to be created. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_vm_count" {
  description = "(Optional) The number of default nodes. Defaults to `1`."
  type        = number
  default     = 1
}
variable "default_nodepool_vm_os_sku" {
  description = <<EOT
  (Optional) Specifies the OS SKU used by the agent pool. Possible values include: `AzureLinux`, `Ubuntu`, `Windows2019` and `Windows2022`.
             If not specified, the default is `Ubuntu` if `OSType=Linux` or `Windows2019` if `OSType=Windows`. And the default Windows OSSKU will be changed to `Windows2022` after `Windows2019` is deprecated.
             temporary_name_for_rotation must be specified when attempting a change. Defaults to `Null`."
  EOT
  type        = string
  default     = null
}
variable "default_nodepool_vm_os_disk_type" {
  description = "(Optional) The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. temporary_name_for_rotation must be specified when attempting a change. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_vm_os_disk_size" {
  description = "(Optional) Specifies the OS Disk Size in GB for the default node pool instances. Defaults to `128`."
  type        = number
  default     = 128
}
variable "default_nodepool_type" {
  description = "(Optional) The type of Node Pool which should be created. Possible values are `AvailabilitySet` and `VirtualMachineScaleSets`. Changing this forces a new resource to be created. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_subnet_id" {
  description = "(Optional) The subnet id for the default nodepool. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_zones" {
  description = <<EOT
  (Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster should be located. temporary_name_for_rotation must be specified when changing this property. Defaults to `Null`."

  Inputs
  ```hcl
  ["1", "2", "3"]
  ```
  EOT
  type        = set(string)
  default     = null
}
variable "default_nodepool_max_pods" {
  description = "(Optional) Specifies the maximum number of pods per default node pool instance. Defaults to `250`."
  type        = number
  default     = 250
}
variable "default_nodepool_autoscaling" {
  description = "(Optional) Enable autoscaling in the default node pool. Defaults to `false`."
  type        = bool
  default     = false
}
variable "default_nodepool_autoscaling_min_count" {
  description = "(Optional) Required when autoscaling is set to `true`. Defaults to `Null`."
  type        = number
  default     = null
}
variable "default_nodepool_autoscaling_max_count" {
  description = "(Optional) Required when autoscaling is set to `true`. Defaults to `Null`."
  type        = number
  default     = null
}
variable "default_nodepool_scale_down_mode" {
  description = "(Optional) Specifies the autoscaling behaviour of the Kubernetes Cluster. Allowed values are `Delete` and `Deallocate`. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_node_labels" {
  description = "(Optional) A map of strings for Kubernetes labels which should be applied to nodes in the Default Node Pool. Defaults to `Null`."
  type        = map(string)
  default     = null
}
variable "default_nodepool_only_critical_addons_enabled" {
  description = "(Optional) Enabling this option will taint default node pool with `CriticalAddonsOnly=true:NoSchedule taint`. temporary_name_for_rotation must be specified when changing this property. Defaults to `false`."
  type        = bool
  default     = false
}
variable "default_nodepool_enable_host_encryption" {
  description = "(Optional) Should the nodes in the Default Node Pool have host encryption enabled? temporary_name_for_rotation must be specified when changing this property. Defaults to `Null`"
  type        = bool
  default     = null
}
variable "default_nodepool_enable_node_public_ip" {
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address? temporary_name_for_rotation must be specified when changing this property. Defaults to `Null`."
  type        = bool
  default     = null
}
variable "default_nodepool_public_ip_prefix" {
  description = "(Optional) Resource ID for the Public IP Addresses Prefix for the nodes in this Node Pool. enable_node_public_ip should be true. Changing this forces a new resource to be created. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_name_for_rotation" {
  description = "(Optional) Specifies the name of the temporary node pool used to cycle the default node pool for VM resizing. Defaults to `defrotation`"
  type        = string
  default     = "defrotation"
}
variable "default_nodepool_ultra_ssd_enabled" {
  description = "(Optional) Used to specify whether the UltraSSD is enabled in the Default Node Pool. temporary_name_for_rotation must be specified when attempting a change. Defauls to `Null`."
  type        = bool
  default     = null
}
variable "default_nodepool_workload_runtime" {
  description = "(Optional) Specifies the workload runtime used by the node pool. Possible values are `OCIContainer` and `KataMshvVmIsolation`. Defaults to `Null`."
  type        = string
  default     = null
}
variable "default_nodepool_fips_enabled" {
  description = "(Optional) Should the nodes in this Node Pool have Federal Information Processing Standard enabled? Changing this forces a new resource to be created. Defaults to `Null`."
  type        = bool
  default     = null
}
variable "aks_additional_node_pools" {
  description = "(Optional) Provide a map of additional node pools for creation with this cluster."
  type = map(object({
    node_count                     = number
    name                           = string
    mode                           = string
    vm_size                        = string
    taints                         = list(string)
    zones                          = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    labels                         = map(string)
    cluster_subnet_id              = string
  }))
}
variable "cost_analysis_enabled" {
  description = "(Optional) Should cost analysis be enabled for this Kubernetes Cluster? The sku_tier must be set to Standard or Premium to enable this feature. Enabling this will add Kubernetes Namespace and Deployment details to the Cost Analysis views in the Azure portal. Defaults to `false`."
  type        = bool
  default     = false
}
variable "node_max_surge" {
  description = "(Required) The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade."
  type        = string
  default     = "33%"
}
variable "drain_timeout_in_minutes" {
  description = "(Optional) The amount of time in minutes to wait on eviction of pods and graceful termination per node. This eviction wait time honors pod disruption budgets for upgrades. If this time is exceeded, the upgrade fails. Unsetting this after configuring it will force a new resource to be created. Defaults to `null`"
  type        = number
  default     = null
}
variable "node_soak_duration_in_minutes" {
  description = "(Optional) The amount of time in minutes to wait after draining a node and before reimaging and moving on to next node. Defaults to `0`."
  type        = number
  default     = 0
}
variable "maintenance_window" {
  description = "(Optional) Maintenance configuration of the managed cluster."
  type = object({
    allowed = optional(list(object({
      day   = string
      hours = set(number)
    })), []),
    not_allowed = optional(list(object({
      end   = string
      start = string
    })), []),
  })
  default = null
}
variable "maintenance_window_auto_upgrade" {
  description = <<EOT
 - `day_of_month` - (Optional) The day of the month for the maintenance run. Required in combination with RelativeMonthly frequency. Value between 0 and 31 (inclusive).
 - `day_of_week` - (Optional) The day of the week for the maintenance run. Options are `Monday`, `Tuesday`, `Wednesday`, `Thurday`, `Friday`, `Saturday` and `Sunday`. Required in combination with weekly frequency.
 - `duration` - (Required) The duration of the window for maintenance to run in hours.
 - `frequency` - (Required) Frequency of maintenance. Possible options are `Daily`, `Weekly`, `AbsoluteMonthly` and `RelativeMonthly`.
 - `interval` - (Required) The interval for maintenance runs. Depending on the frequency this interval is week or month based.
 - `start_date` - (Optional) The date on which the maintenance window begins to take effect.
 - `start_time` - (Optional) The time for maintenance to begin, based on the timezone determined by `utc_offset`. Format is `HH:mm`.
 - `utc_offset` - (Optional) Used to determine the timezone for cluster maintenance.
 - `week_index` - (Optional) The week in the month used for the maintenance run. Options are `First`, `Second`, `Third`, `Fourth`, and `Last`.

 ---
 `not_allowed` block supports the following:
 - `end` - (Required) The end of a time span, formatted as an RFC3339 string.
 - `start` - (Required) The start of a time span, formatted as an RFC3339 string.
EOT
  type = object({
    day_of_month = optional(number)
    day_of_week  = optional(string)
    duration     = number
    frequency    = string
    interval     = number
    start_date   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    week_index   = optional(string)
    not_allowed = optional(set(object({
      end   = string
      start = string
    })))
  })
  default = null
}
variable "maintenance_window_node_os" {
  description = <<EOT
 - `day_of_month` - (Optional) The day of the month for the maintenance run. Required in combination with RelativeMonthly frequency. Value between 0 and 31 (inclusive).
 - `day_of_week` - (Optional) The day of the week for the maintenance run. Options are `Monday`, `Tuesday`, `Wednesday`, `Thurday`, `Friday`, `Saturday` and `Sunday`. Required in combination with weekly frequency.
 - `duration` - (Required) The duration of the window for maintenance to run in hours.
 - `frequency` - (Required) Frequency of maintenance. Possible options are `Daily`, `Weekly`, `AbsoluteMonthly` and `RelativeMonthly`.
 - `interval` - (Required) The interval for maintenance runs. Depending on the frequency this interval is week or month based.
 - `start_date` - (Optional) The date on which the maintenance window begins to take effect.
 - `start_time` - (Optional) The time for maintenance to begin, based on the timezone determined by `utc_offset`. Format is `HH:mm`.
 - `utc_offset` - (Optional) Used to determine the timezone for cluster maintenance.
 - `week_index` - (Optional) The week in the month used for the maintenance run. Options are `First`, `Second`, `Third`, `Fourth`, and `Last`.

 ---
 `not_allowed` block supports the following:
 - `end` - (Required) The end of a time span, formatted as an RFC3339 string.
 - `start` - (Required) The start of a time span, formatted as an RFC3339 string.
EOT
  type = object({
    day_of_month = optional(number)
    day_of_week  = optional(string)
    duration     = number
    frequency    = string
    interval     = number
    start_date   = optional(string)
    start_time   = optional(string)
    utc_offset   = optional(string)
    week_index   = optional(string)
    not_allowed = optional(set(object({
      end   = string
      start = string
    })))
  })
  default = null
}
variable "linux_profile" {
  description = "(Optional) Username and ssh key for accessing AKS Linux nodes with ssh. Defaults to `Null`."
  type = object({
    username = string,
    ssh_key  = string
  })
  default = null
}
variable "windows_profile" {
  description = "(Optional) Admin username and password for Windows hosts. Defaults to `Null`."
  type = object({
    username = string
    password = string
  })
  default = null
}
variable "net_mode" {
  description = <<EOT
  (Optional) Set the network mode to use for networking. Defaults to `Null`.

  Options:
  - bridge
  - transparent
  EOT
  type        = string
  default     = null
  validation {
    condition = (
      var.net_mode == null ||
    can(regex("^bridge$|^transparent$", var.net_mode)))
    error_message = "You must specify a valid network mode of bridge or transparent."
  }
}
variable "net_plugin" {
  description = <<EOT
  (Optional) Set the network plugin type to use for networking. Defaults to `azure`.

  Options:
  - azure
  - kubenet
  - none
  EOT
  type        = string
  default     = "azure"
  validation {
    condition = (
    can(regex("^azure$|^kubenet$|^none$", var.net_plugin)))
    error_message = "You must specify a valid network plugin type of azure, kubenet or none."
  }
}
variable "net_plugin_mode" {
  description = <<EOT
  (Optional) Set the network plugin mode to use for networking. Defaults to `Null`.

  Options:
  - overlay
  EOT
  type        = string
  default     = null
  validation {
    condition = (
      var.net_plugin_mode == null ||
    can(regex("^overlay$", var.net_plugin_mode)))
    error_message = "You must specify a valid network plugin mode of overlay."
  }
}
variable "net_policy" {
  description = <<EOT
  (Optional) Sets up the network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Changing this after cluster creation will force recreation. Defaults to `Null`.

  Options:
  - azure
  - calico
  - cilium
  EOT
  type        = string
  default     = null
  validation {
    condition = (
      var.net_policy == null ||
    can(regex("^azure$|^calico$|^cilium$|^null$", var.net_policy)))
    error_message = "You must specify a valid network policy type of azure or calico."
  }
}
variable "net_data_plane" {
  description = <<EOT
  (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Defaults to `azure`.

  Options:
  - azure
  - cilium
  EOT
  type        = string
  default     = "azure"
  validation {
    condition = (
    can(regex("^azure$|^cilium$|^null$", var.net_data_plane)))
    error_message = "You must specify a valid network policy type of azure or cilium."
  }
}

variable "net_profile_dns_service_ip" {
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created. Defaults to `10.2.0.10`."
  type        = string
  default     = "10.2.0.10"
}
variable "net_profile_service_cidr" {
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created. Defaults to `10.2.0.0/16`"
  type        = string
  default     = "10.2.0.0/16"
}
variable "net_profile_pod_cidr" {
  description = "(Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created. Defaults to `Null`."
  type        = string
  default     = null
}
variable "net_dataplane" {
  description = <<EOT
  (Optional) Set the data plane of the Azure CNI. When set network_plugin must be set to azure. Defaults to `Null`.

  Options:
  - cilium
  EOT
  type        = string
  default     = null
  validation {
    condition = (
      var.net_dataplane == null ||
    can(regex("^cilium$", var.net_dataplane)))
    error_message = "You must specify a valid network data plane of cilium."
  }
}
variable "net_ip_versions" {
  description = "(Optional) Specifies a list of IP versions the Kubernetes Cluster will use to assign IP addresses to its nodes and pods. Possible values are `[\"IPv4\"]` or `[\"IPv4\", \"IPv6\"]`. `IPv4` must always be specified. Changing this forces a new resource to be created. Defaults to `Null`."
  type        = list(string)
  default     = null
}
variable "net_profile_outbound_type" {
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer`, `userDefinedRouting`, `managedNATGateway` and `userAssignedNATGateway`. Defaults to `loadBalancer`."
  type        = string
  default     = "loadBalancer"
}
variable "net_profile_loadbalancer_sku" {
  description = "(Optional) The loadbalancer sku to be used. Possible values are `standard` or `basic`. Defaults to `standard`."
  type        = string
  default     = "standard"
}
variable "load_balancer_profile_enabled" {
  description = "(Optional) Set to true to enable custom Azure Load Balancer profile for outbound connectivity. Defaults to `False`."
  type        = bool
  default     = false
}
variable "nat_gateway_profile_enabled" {
  description = "(Optional) Set to true to customise the Azure Nat Gateway Profile for this Azure Kubernetes Cluster. Defaults to `False`."
  type        = bool
  default     = false
}
variable "net_azlb_managed_outbound_ipv4_count" {
  description = "(Optional) Set the number of outbound public IPv4 addresses for the Azure Load Balancer. Values between `1` and `100`. Defaults to `1`."
  type        = number
  default     = 1
}
variable "net_azlb_managed_outbound_ipv6_count" {
  description = "(Optional) Set the number of outbound public IPv6 addresses for the Azure Load Balancer. Values between `1` and `100`. Defaults to `Null`."
  type        = number
  default     = null
}
variable "net_azlb_idle_timeout_in_minutes" {
  description = "(Optional) Set the idle timeout before reset for the Azure Load Balancer. Values between `4` and `120`. Defaults to `30`."
  type        = number
  default     = 30
}
variable "net_azlb_ports_allocated_per_instance" {
  description = "(Optional) Set the number of ports per backend instance for the Azure Load Balancer. Values between `0` and `64000` where `0` is automatic allocation. Defaults to `0`."
  type        = number
  default     = 0
}
variable "net_aznatgw_outbound_ip_count" {
  description = "(Optional) Set the number of outbound public IPv4 addresses for the Azure Nat Gateway. Values between `1` and `100`. Defaults to `1`."
  type        = number
  default     = 1
}
variable "net_aznatgw_idle_timeout_in_minutes" {
  description = "(Optional) Set the idle timeout before reset for the Azure Nat Gateway. Values between `4` and `120`. Defaults to `4`."
  type        = number
  default     = 4
}
variable "service_mesh_envoy_enabled" {
  description = "(Optional) Set to true to enable Open Service Mesh addon which runs Envoy on the cluster. This is not the same as Istio Service Mesh which uses the service_mesh_istio_profile. Defaults to `Null`."
  type        = bool
  default     = false
}
variable "service_mesh_istio_profile_enabled" {
  description = "Set to true to enable the Istio Service Mesh and then set the service_mesh_istio_profile as required. Defaults to `false`."
  type        = bool
  default     = false
}
variable "service_mesh_istio_profile" {
  description = <<EOT
  (Optional) Provide a map with settings for the Istio Service Mesh. Defaults to `Istio`.

  service_mesh_istio_profile = {
    mode = "Istio"
  }
  EOT
  type = object({
    mode = string
  })
  default = {
    mode = "Istio"
  }
}
variable "ingress_application_gateway_enabled" {
  description = "(Optional) Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster? Defaults to `false`."
  type        = bool
  default     = false
}
variable "ingress_application_gateway_id" {
  description = "(Optional) The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster. Defaults to `Null`."
  type        = string
  default     = null
}
variable "ingress_application_gateway_name" {
  description = "(Optional) The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. Defaults to `Null`."
  type        = string
  default     = null
}
variable "ingress_application_gateway_subnet_cidr" {
  description = "(Optional) The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. Defaults to `Null`."
  type        = string
  default     = null
}
variable "ingress_application_gateway_subnet_id" {
  description = "(Optional) The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster. Defaults to `Null`."
  type        = string
  default     = null
}
variable "dns_prefix" {
  description = "(Optional) Prefix for hostnames that are created. If not specified, this generate a hostname using the managed cluster and resource group names. Defaults to `Empty`."
  type        = string
  default     = ""
}
variable "enable_http_application_routing" {
  description = "(Optional) Enable HTTP Application Routing Addon (forces recreation). Defaults to `false`."
  type        = bool
  default     = false
}
variable "local_account_disabled" {
  description = "(Optional) You disable the local admin account of the cluster. Use it carefully because it impacts Service Principals on Azure DevOps. Defaults to `false`."
  type        = bool
  default     = false
}
variable "enable_azure_policy" {
  description = "(Optional) Enable Azure Policy Addon. Defaults to `true`."
  type        = bool
  default     = true
}
variable "enable_log_analytics_workspace" {
  description = "(Optional) Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not. Defaults to `false`."
  type        = bool
  default     = false
}
variable "log_analytics_workspace_id" {
  description = "(Optional) The resource id of the Azure Log Analytics Workspace. Defaults to `null`."
  type        = string
  default     = null
}
variable "microsoft_defender_enabled" {
  description = "(Optional) Is Microsoft Defender on the cluster enabled? Requires `var.log_analytics_workspace_enabled` to be `true` to set this variable to `true`. Defaults to `false`."
  type        = bool
  default     = false
}
variable "key_vault_secrets_provider_enabled" {
  description = "(Optional) Whether to use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster. For more details: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver. Defaults to `false`."
  type        = bool
  default     = false
}
variable "secret_rotation_enabled" {
  description = "(Optional) Is secret rotation enabled? This variable is only used when `key_vault_secrets_provider_enabled` is `true` and defaults to `false`"
  type        = bool
  default     = false
}
variable "secret_rotation_interval" {
  description = "(Optional) The interval to poll for secret rotation. This attribute is only set when `secret_rotation` is `true` and defaults to `2m`"
  type        = string
  default     = "2m"
}
variable "auto_scaler_profile" {
  description = "(Optional) Configuration of `auto_scaler_profile` block object. Defaults to `Null`."
  type = object({
    balance_similar_node_groups      = optional(bool, false)
    expander                         = optional(string, "random")
    max_graceful_termination_sec     = optional(number, 600)
    max_node_provisioning_time       = optional(string, "15m")
    max_unready_nodes                = optional(number, 3)
    max_unready_percentage           = optional(number, 45)
    new_pod_scale_up_delay           = optional(string, "10s")
    scale_down_delay_after_add       = optional(string, "10m")
    scale_down_delay_after_delete    = optional(string, "10s")
    scale_down_delay_after_failure   = optional(string, "3m")
    scan_interval                    = optional(string, "10s")
    scale_down_unneeded              = optional(string, "10m")
    scale_down_unready               = optional(string, "20m")
    scale_down_utilization_threshold = optional(number, 0.5)
    empty_bulk_delete_max            = optional(number, 10)
    skip_nodes_with_local_storage    = optional(bool, true)
    skip_nodes_with_system_pods      = optional(bool, true)
  })
  default = null
}
variable "storage_profile_blob_driver_enabled" {
  description = "(Optional) Is the Blob CSI driver enabled? Defaults to `false`"
  type        = bool
  default     = false
}
variable "storage_profile_disk_driver_enabled" {
  description = "(Optional) Is the Disk CSI driver enabled? Defaults to `true`"
  type        = bool
  default     = true
}
variable "storage_profile_disk_driver_version" {
  description = "(Optional) Disk CSI Driver version to be used. Possible values are `v1` and `v2`. Defaults to `v1`."
  type        = string
  default     = "v1"
}
variable "storage_profile_enabled" {
  description = "(Optional) Enable storage profile?"
  type        = bool
  default     = false
}
variable "storage_profile_file_driver_enabled" {
  description = "(Optional) Is the File CSI driver enabled? Defaults to `true`"
  type        = bool
  default     = true
}
variable "storage_profile_snapshot_controller_enabled" {
  description = "(Optional) Is the Snapshot Controller enabled? Defaults to `true`"
  type        = bool
  default     = true
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
