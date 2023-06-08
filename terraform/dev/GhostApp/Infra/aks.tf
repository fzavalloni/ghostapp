data "azuread_groups" "akscluster01-admins" {
  display_names    = ["Global-Administrators"]
  security_enabled = true
}

module "akscluster01" {
  #checkov:skip=CKV_AZURE_170:Ensure that AKS use the Paid Sku for its SLA. Not applicable
  source                                = "../../../modules/terraform-azure-aks"

  resource_group_name                   = module.resource-group-01.name
  nodes_resource_group_name             = "${var.environment-prefix}AKSCluster01-Resources"
  cluster_name                          = "${var.environment-prefix}AKSCluster01"
  location                              = var.location
  dns_prefix                            = "local"
  subnet_id_default_nodepool            = module.vnet01.vnet_subnets[7]
  rbac_aad_admin_group_object_ids       = data.azuread_groups.akscluster01-admins.object_ids
  log_analytics_workspace_id            = module.log01.log_analytics_workspace_id
  enable_log_analytics_workspace        = true
  kubernetes_version                    = "1.26.3"
  sku_tier                              = "Free"
  private_cluster_enabled               = false
  enable_azure_policy                   = true
  ingress_application_gateway_enabled   = true
  microsoft_defender_enabled            = true
  key_vault_secrets_provider_enabled    = true
  ingress_application_gateway_name      = "${var.environment-prefix}AppGateway"
  ingress_application_gateway_subnet_id = module.vnet01.vnet_subnets[5]
  vm_size_default_nodepool              = "Standard_B2s"

  aks_additional_node_pools = {
    hpfpool01 = {
      node_count                     = 1      
      mode                           = "User"
      name                           = "apppool01"
      vm_size                        = "Standard_B2s"
      zones                          = ["1"]
      taints                         = null
      labels = {
        nodepool : "apppool01"        
      }
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      cluster_subnet_id              = module.vnet01.vnet_subnets[7]
    }
  }  
    
  depends_on = [
    module.vnet01,    
    module.log01
  ]
}
