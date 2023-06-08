terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.37.0"
    }    
  }  
}

provider "azurerm" {  
  features {}
}

data "azurerm_kubernetes_cluster" "akscluster01" {
  name                = "GhostApp-AKSCluster01"
  resource_group_name = "GhostApp-RSG"
}

data "azurerm_mysql_flexible_server" "mysql-db" {
  name                = "mysql-ghost"
  resource_group_name = "GhostApp-RSG"
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
