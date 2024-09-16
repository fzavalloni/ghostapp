#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Outputs
*/
#------------------------------------------------------------------------------------------------------------------------------------------
# output "cluster_extension_id" {
#   value       = try(azurerm_kubernetes_cluster_extension.aks-backup-extension.id, null)
#   description = "The ID of the Kubernetes Cluster Extension."
# }
# output "cluster_extension_version" {
#   value       = try(azurerm_kubernetes_cluster_extension.aks-backup-extension.current_version, null)
#   description = "The current version of the Kubernetes Cluster Extension."
# }
# output "backup_policy_id" {
#   description = "The ID of the Backup Policy Kubernetes Cluster."
#   value       = try(azurerm_data_protection_backup_policy_kubernetes_cluster.main[0].id, null)
# }
# output "backup_instance_id" {
#   description = "The ID of the Backup Instance Kubernetes Cluster."
#   value       = try(azurerm_data_protection_backup_instance_kubernetes_cluster.main.id, null)
# }
