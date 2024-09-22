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
variable "subscription_id" {
  description = "(Required) Azure Subscription Id."
  type        = string
}
variable "tenant_id" {
  description = "(Required) Azure AD Tenant Id."
  type        = string
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
variable "enable_kubernetes_configuration_provider" {
  description = "(Optional) Set to `true` to enable the Microsoft.KubernetesConfiguration resource at the Subscription level. Defaults to `false`."
  type        = bool
  default     = false
}
variable "backup_instance_name" {
  description = "(Required) The name which should be used for this Backup Instance Kubernetes Cluster."
  type        = string
}
variable "backup_vault_aks_policy_id" {
  description = "(Optional) The ID of the Backup Policy."
  type        = string
  default     = null
}
variable "backup_datasource_parameters" {
  description = <<EOT
  (Optional) Backup datasource parameters.

  #Example Input
  ```hcl
  backup_datasource_parameters = {
    excluded_namespaces              = ["kube-system", "default"]
    excluded_resource_types          = ["configmaps", "secrets"]
    cluster_scoped_resources_enabled = true
    included_namespaces              = ["namespace1", "namespace2"]
    included_resource_types          = ["deployments", "pods"]
    label_selectors                  = ["app=nginx", "tier=frontend"]
    volume_snapshot_enabled          = true
  }
  ```
  EOT
  type = object({
    excluded_namespaces              = optional(list(string))
    excluded_resource_types          = optional(list(string))
    cluster_scoped_resources_enabled = optional(bool)
    included_namespaces              = optional(list(string))
    included_resource_types          = optional(list(string))
    label_selectors                  = optional(list(string))
    volume_snapshot_enabled          = optional(bool)
  })
  default = null
}
variable "create_backup_policy" {
  description = "(Required) Boolean flag to indicate whether to create the backup policy."
  type        = bool
  default     = false
}
variable "backup_policy_configuration" {
  description = <<EOT
  (Optional) Configuration for the backup policy.

  #Example Input
  ```hcl
  backup_policy_configuration = {
    name                              = "example-backup-policy"
    backup_policy_resource_group_name = "example-resource-group"
    backup_vault_name                 = "example-backup-vault"
    backup_repeating_time_intervals   = ["daily", "weekly"]
    time_zone                         = "UTC"
    retention_rules = [
      {
        name     = "weekly-retention"
        priority = 1
        life_cycle = {
          duration        = "P4M"
          data_store_type = "OperationalStore"
        }
        criteria = {
          absolute_criteria      = "weekly"
          days_of_week           = ["Monday"]
          months_of_year         = ["*"]
          scheduled_backup_times = ["03:00"]
          weeks_of_month         = []
        }
      },
      {
        name     = "monthly-retention"
        priority = 2
        life_cycle = {
          duration        = "P1Y"
          data_store_type = "ArchivalStore"
        }
        criteria = {
          absolute_criteria      = "monthly"
          days_of_week           = []
          months_of_year         = ["January"]
          scheduled_backup_times = ["04:00"]
          weeks_of_month         = []
        }
      }
    ]
  }
  ```
  EOT  
  type = object({
    name                              = string
    backup_policy_resource_group_name = string
    backup_vault_name                 = string
    backup_repeating_time_intervals   = list(string)
    time_zone                         = optional(string)
    default_retention_duration        = optional(string, "P4M")
    retention_rules = optional(list(object({
      name     = string
      priority = number
      life_cycle = object({
        duration        = string
        data_store_type = string
      })
      criteria = object({
        absolute_criteria      = optional(string)
        days_of_week           = optional(list(string))
        months_of_year         = optional(list(string))
        scheduled_backup_times = optional(list(string))
        weeks_of_month         = optional(list(string))
      })
    })))
  })
  default = null
}
