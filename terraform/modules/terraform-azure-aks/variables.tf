variable "tags" {
  description = "(Optional) Any tags that should be defined on resources"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "(Required) The name of the cluster. If there is no prefix, this name will be used for the cluster."
  type        = string  
}

variable "location" {
  description = "(Required) The location of the cluster. Optional value are `az account list-locations -o table`"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the cluster"
  type        = any
}

variable "ingress_application_gateway_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?"
  nullable    = false
}

variable "ingress_application_gateway_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster."
}

variable "ingress_application_gateway_name" {
  type        = string
  default     = null
  description = "(Optional) The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}

variable "ingress_application_gateway_subnet_cidr" {
  type        = string
  default     = null
  description = "(Optional) The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}

variable "ingress_application_gateway_subnet_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
}

variable "dns_prefix" {
  description = "(Optional) Prefix for hostnames that are created. If not specified, this generate a hostname using the managed cluster and resource group names"
  type        = string
  default     = ""
}

variable "nodes_resource_group_name" {
 description = "(Required) Name for the resource group for the cluster resources"
 type        = string
}

variable "kubernetes_version" {
  type        = string
  description = "(Optional) Kubernetes Version - az aks get-versions --location westeurope --output table"
  default     = "1.22.2"
}

variable "sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Paid"
}

variable "private_cluster_enabled" {
  description = "(Optional) If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = bool
  default     = false
}

//identity block
variable "identity_type" {
  description = "(Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, a `user_assigned_identity_id` must be set as well."
  type        = string
  default     = "SystemAssigned"
}

//default nodepool block
variable "vm_size_default_nodepool" {
  type        = string
  description = "(Optional) Azure VM node size e.g. Standard_D2s_v3 or Standard_B4ms - az vm list-sizes --location westeurope"
  default     = "Standard_B2ms"
}

variable "vm_count_default_nodepool" {
  type        = string
  description = "(Optional) The number of default nodes"
  default     = 1
}

variable "subnet_id_default_nodepool" {
  description = "(Optional) The subnet id for the default nodepool"
  type        = string
  default     = null
}

variable "autoscaling_default_nodepool" {
  description = "(Optional) Enable autoscaling in the default node pool"
  type        = bool
  default     = false
}

variable "autoscaling_min_count_default_nodepool" {
  description = "(Optional) Required when autoscaling is set to true"
  type        = number
  default     = null
}

variable "autoscaling_max_count_default_nodepool" {
  description = "(Optional) Required when autoscaling is set to true"
  type        = number
  default     = null
}

variable "api_server_authorized_ip_ranges" {
  description = "(Optional) The IP ranges to whitelist for incoming traffic to the masters."
  type        = list(string)
  default     = null
}

//linux profile block
variable "linux_profile" {
  description = "(Optional) Username and ssh key for accessing AKS Linux nodes with ssh."
  type = object({
    username = string,
    ssh_key  = string
  })
  default = null
}

variable "windows_profile" {
  description = "(Optional) Admin username and password for Windows hosts."
  type = object({
    username = string
    password = string
  })
  default = null
}

//network profile block
variable "net_profile_docker_bridge_cidr" {
  description = "(Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  type        = string
  default     = "172.17.0.1/16"
}

variable "net_profile_dns_service_ip" {
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  type        = string
  default     = "10.2.0.10"
}

variable "net_profile_service_cidr" {
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
  default     = "10.2.0.0/16"
}

variable "net_profile_loadbalancer_sku" {
  description = "(Optional) The loadbalancer sku to be used. Can be standard or basic."
  type        = string
  default     = "standard"
}

variable "network_plugin" {
  description = "(Optional) Network plugin to use for networking."
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "(Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "net_profile_outbound_type" {
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
  type        = string
  default     = "loadBalancer"
}

variable "net_profile_pod_cidr" {
  description = "(Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

// rbac block
variable "rbac_enabled" {
  description = "(Optional) Enable Role Based Access Control."
  type        = bool
  default     = true
}

variable "rbac_aad_managed" {
  description = "(Optional) Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  type        = bool
  default     = true
}

variable "rbac_aad_admin_group_object_ids" {
  description = "(Optional) Object ID of groups with admin access."
  type        = any
  default     = null
}

// addon profile block
variable "enable_http_application_routing" {
  description = "(Optional) Enable HTTP Application Routing Addon (forces recreation)."
  type        = bool
  default     = false
}

variable "local_account_disabled" {
  description = "(Optional) You disable the local admin account of the cluster. Use it carefully because it impacts Service Principals on Azure Devops"
  type        = bool
  default     = false
} 

variable "enable_azure_policy" {
  description = "(Optional) Enable Azure Policy Addon."
  type        = bool
  default     = true
}

variable "enable_log_analytics_workspace" {
  type        = bool
  description = "(Optional) Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "(Optional) The resource id of the log analytics workspace"
  type        = string
}

variable "aks_additional_node_pools" {
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

variable "microsoft_defender_enabled" {
  type        = bool
  description = "(Optional) Is Microsoft Defender on the cluster enabled? Requires `var.log_analytics_workspace_enabled` to be `true` to set this variable to `true`."
  default     = false
  nullable    = false
}

variable "key_vault_secrets_provider_enabled" {
  type        = bool
  description = "(Optional) Whether to use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster. For more details: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver"
  default     = false
  nullable    = false
}

variable "secret_rotation_enabled" {
  type        = bool
  description = "(Optional) Is secret rotation enabled? This variable is only used when `key_vault_secrets_provider_enabled` is `true` and defaults to `false`"
  default     = false
  nullable    = false
}

variable "secret_rotation_interval" {
  type        = string
  default     = "2m"
  description = "The interval to poll for secret rotation. This attribute is only set when `secret_rotation` is `true` and defaults to `2m`"
  nullable    = false
}

variable "auto_scaler_profile" {
  description = "(Optional) Configuration of `auto_scaler_profile` block object"
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