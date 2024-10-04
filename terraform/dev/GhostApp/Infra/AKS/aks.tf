data "azuread_groups" "akscluster01-admins" {
  display_names    = ["Global-Administrators"]
  security_enabled = true
}

module "akscluster01" {
  #checkov:skip=CKV_AZURE_170:Ensure that AKS use the Paid Sku for its SLA. Not applicable
  source                                = "git::https://fzavalloni10@dev.azure.com/fzavalloni10/CCOE/_git/terraform-azure-aks?ref=v1.0.0"

  resource_group_name                   = module.resource-group-01.name
  nodes_resource_group_name             = "${var.environment-prefix}AKSCluster01-Resources"
  cluster_name                          = "${var.environment-prefix}AKSCluster01"
  location                              = var.location
  dns_prefix                            = "local"
  default_nodepool_subnet_id            = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[7]
  rbac_aad_admin_group_object_ids       = data.azuread_groups.akscluster01-admins.object_ids
  log_analytics_workspace_id            = module.log01.log_analytics_workspace_id
  enable_log_analytics_workspace        = true
  kubernetes_version                    = "1.30.3"
  sku_tier                              = "Free"
  private_cluster_enabled               = false
  enable_azure_policy                   = true
  ingress_application_gateway_enabled   = false
  microsoft_defender_enabled            = true
  key_vault_secrets_provider_enabled    = true
  msi_auth_for_monitoring_enabled       = true
  oidc_issuer_enabled                   = true
  workload_identity_enabled             = true
  #ingress_application_gateway_name      = "${var.environment-prefix}AppGateway"
  #ingress_application_gateway_subnet_id = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[5]

  default_nodepool_vm_size              = "Standard_B4ms"
  net_policy                            = "azure"
  net_data_plane                        = "azure"

  aks_additional_node_pools = {
    apppool01 = {
      node_count                     = 1
      mode                           = "System" #"User" Set it to system in order to no pay for the running node due Basic tier
      name                           = "apppool01"
      vm_size                        = "Standard_B4ms"
      zones                          = ["1"]
      taints                         = null
      labels = {
        nodepool : "apppool01"
      }
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      cluster_subnet_id              = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[7]
    }
  }

  monitor_metrics = {
    annotations_allowed = "environment, owner, team, app-version"
    labels_allowed      = "app, tier, release, environment"
  }

  depends_on = [
    module.log01
  ]
}
