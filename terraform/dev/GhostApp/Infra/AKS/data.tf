data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = "Terraform"
    storage_account_name = "ghospappterraform"
    container_name       = "ghostapp-statefile"
    key                  = "shared-statefile.tfstate"
    subscription_id      = "3b5f1238-e3ee-4a8d-93fa-6bb7f33c7233"
  }
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}

data "azurerm_kubernetes_cluster" "akscluster01" {
  name                = module.akscluster01.name
  resource_group_name = module.resource-group-01.name
}

provider "kubernetes" {  
  host                   = data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {    
    host                   = data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.akscluster01.kube_admin_config.0.cluster_ca_certificate)
  }
}