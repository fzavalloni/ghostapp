#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Variables
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Resource Group and Locations
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "aks_cluster_name" {
  description = "(Required) Specifies the Azure Kubernetes Cluster name on which to enable backup."
  type        = string
  nullable    = false
}

variable "aks_cluster_id" {
  description = "(Required) Specifies the Azure Kubernetes Cluster ID on which to enable backup."
  type        = string
  nullable    = false
}
variable "aks_cluster_resource_group_id" {
  description = "(Required) ID of the resource group where the Azure Kubernetes Cluster is deployed."
  type        = string
  nullable    = false
}

variable "aks_system_assigned_identity" {
  description = "(Required) AKS System Managed Identity."
  type        = string
  nullable    = false
}

variable "location" {
  description = "(Required) Location to be used when creating this Azure Kubernetes Cluster Backup."
  type        = string
  nullable    = false
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Notices

  1.  Backup Storage AKS backup uses a blob container and a resource group to store the backups. The blob container has the AKS cluster 
      resources stored in it, whereas the persistent volume snapshots are stored in the resource group. The AKS cluster and the storage 
      locations must reside in the same region.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
variable "backup_storage_name" {
  description = "(Required) Backup Storage Name"
  type        = string
  nullable    = false
}

variable "backup_storage_id" {
  description = "(Required) Backup Storage Id"
  type        = string
  nullable    = false
}
variable "backup_storage_resource_group" {
  description = "(Required) Resource Group name where the Storage Resource is placed"
  type        = string
  nullable    = false
}
variable "backup_storage_resource_group_id" {
  description = "(Required) Resource Group Id where the Storage Resource is placed"
  type        = string
  nullable    = false
}
variable "backup_storage_container" {
  description = "(Required) Backup Storage Container"
  type        = string
  nullable    = false
}
variable "backup_vault_name" {
  description = "(Required) The Azure Backup Vault that controls the AKS Backup"
  type        = string
  nullable    = false
}

variable "backup_vault_id" {
  description = "(Required) The Azure Backup Vault Id that controls the AKS Backup"
  type        = string
  nullable    = false
}

variable "backup_vault_identity" {
  description = "(Required) The Azure Backup Vault managed Identity that controls the AKS Backup"
  type        = string
  nullable    = false
}
variable "backup_vault_resource_group" {
  description = "(Required) The resource group name where the Azure Backup Vault is placed."
  type        = string
  nullable    = false
}
variable "backup_vault_aks_policy_name" {
  description = "(Optional) AKS Policy Name created within the Azure Backup Vault. Defaults to `AKSDefaultBackupPolicy`."
  type        = string
  default     = "AKSDefaultBackupPolicy"
}
variable "backup_vault_aks_policy_repeating_interval" {
  description = "(Optional) Specifies the backup interval for this Azure Kubernetes Backup. Valid inputs are `Daily` and Weekly`. Defaults to `Daily`."
  type        = string
  default     = "Daily"
  validation {
    condition     = contains(["Daily", "Weekly"], var.backup_vault_aks_policy_repeating_interval)
    error_message = "Invalid input, options: \"Daily\"and \"Weekly\" ."
  }
}
variable "backup_vault_aks_policy_repeating_interval_count" {
  description = "(Optional) Specifies this Azure Kubernetes Backup policy interval count. Defaults to `1`."
  type        = number
  default     = 1
}
variable "backup_vault_aks_policy_retention_weeks" {
  description = "(Optional) Specifies the amount of weeks the backup is preserved before the rotation. Defaults to `4`."
  type        = number
  default     = 4
}
variable "enable_kubernetes_configuration_provider" {
  description = "(Optional) Set to `true` to enable the Microsoft.KubernetesConfiguration resource at the Subscription level. Defaults to `false`."
  type        = bool
  default     = false
}

variable "subscription_id" {
  description = "(Required) Azure Subscription Id."
  type        = string  
}

variable "tenant_id" {
  description = "(Required) Azure AD Tenant Id."
  type        = string  
}
