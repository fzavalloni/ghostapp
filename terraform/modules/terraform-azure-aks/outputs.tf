output "aks_id" {
  description = "The ID for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.id, null)
}
output "name" {
  description = "The name of this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.name, null)
}
output "kube_config_raw" {
  description = "The KubeConfig for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config_raw, null)
  sensitive   = true
}
output "system_assigned_identity" {
  description = "The identity assigned to this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.identity[0].principal_id, null)
}
output "kubelet_identity" {
  description = "The kubelet identity assigned to this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id, null)
}
output "node_resource_group" {
  description = "The nodes resource group for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.node_resource_group, null)
}
output "location" {
  description = "The location for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.location, null)
}
output "client_key" {
  description = "The client key for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config[0].client_key, null)
}
output "client_certificate" {
  description = "The client certificate for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config[0].client_certificate, null)
}
output "cluster_ca_certificate" {
  description = "The cluster CA certificate for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate, null)
}
output "host" {
  description = "The host for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config[0].host, null)
}
output "username" {
  description = "The username for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config[0].username, null)
}
output "password" {
  description = "The password for this Azure Kubernetes Service."
  value       = try(azurerm_kubernetes_cluster.main.kube_config[0].password, null)
}
output "http_application_routing_zone_name" {
  description = "The http application routing zone name for this Azure Kubernetes Service."
  value       = azurerm_kubernetes_cluster.main.http_application_routing_zone_name != null ? azurerm_kubernetes_cluster.main.http_application_routing_zone_name : null
}
output "admin_client_key" {
  description = "The admin client key for this Azure Kubernetes Service."
  value       = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config[0].client_key : null
}
output "admin_client_certificate" {
  description = "The admin client certificate for this Azure Kubernetes Service."
  value       = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config[0].client_certificate : null
}
output "admin_cluster_ca_certificate" {
  description = "The admin cluster ca certificate for this Azure Kubernetes Service."
  value       = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config[0].cluster_ca_certificate : null
}
output "admin_host" {
  description = "The admin host for this Azure Kubernetes Service."
  value       = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config[0].host : null
}
output "admin_username" {
  description = "The admin user name for this Azure Kubernetes Service."
  value       = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config[0].username : null
}
output "admin_password" {
  description = "The admin password for this Azure Kubernetes Service."
  value       = length(azurerm_kubernetes_cluster.main.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.main.kube_admin_config[0].password : null
}
output "admin_group_object_ids" {
  description = "The admin group object IDs for this Azure Kubernetes Service."
  value       = try(resource.azurerm_kubernetes_cluster.main.azure_active_directory_role_based_access_control[0], null)
}
output "ingress_application_gateway_identity_object_id" {
  description = "The ID of the ingress application gateway for this Azure Kubernetes Service."
  value       = length(resource.azurerm_kubernetes_cluster.main.ingress_application_gateway) > 0 ? resource.azurerm_kubernetes_cluster.main.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id : null
}
output "key_vault_secrets_provider_identity_object_id" {
  description = "The ObjectId of the identity for Key Vault Secrets Provider for this Azure Kubernetes Service"
  value       = length(resource.azurerm_kubernetes_cluster.main.key_vault_secrets_provider) > 0 ? resource.azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id : null
}
output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  value       = try(resource.azurerm_kubernetes_cluster.main.oidc_issuer_url, null)
}
