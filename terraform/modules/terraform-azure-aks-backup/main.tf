terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
resource "azurerm_resource_provider_registration" "this" {
  count = var.enable_kubernetes_configuration_provider ? 1 : 0
  name  = "Microsoft.KubernetesConfiguration"
}
resource "azurerm_kubernetes_cluster_extension" "aks-backup-extension" {
  name           = "azure-aks-backup"
  cluster_id     = var.aks_cluster_id
  extension_type = "microsoft.dataprotection.kubernetes"
  configuration_settings = {
    "configuration.backupStorageLocation.bucket"                = var.backup_storage_container
    "configuration.backupStorageLocation.config.resourceGroup"  = var.backup_storage_resource_group
    "configuration.backupStorageLocation.config.storageAccount" = var.backup_storage_name
    "configuration.backupStorageLocation.config.subscriptionId" = var.subscription_id
    "credentials.tenantId"                                      = var.tenant_id
  }
}
resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "this" {
  kubernetes_cluster_id = var.aks_cluster_id
  name                  = "BackupVaultBind"
  roles                 = ["Microsoft.DataProtection/backupVaults/backup-operator"]
  source_resource_id    = var.backup_vault_id
}
module "vault01-permissions" {
  source = "../terraform-azure-aad-role-assignment-name"

  assignments = {
    "BackupVault-Permission-In-AKSCluster" = {
      role_definition_name             = "Reader"
      principal_id                     = var.backup_vault_identity
      scope                            = var.aks_cluster_id
      skip_service_principal_aad_check = true
    },
    "BackupVault-Permission-In-BackupStorageAccount-Resource-Group" = {
      role_definition_name             = "Reader"
      principal_id                     = var.backup_vault_identity
      scope                            = var.backup_storage_resource_group_id
      skip_service_principal_aad_check = true
    },
    "BackupVault-Permission-In-AKS-Resource-Group" = {
      role_definition_name             = "Reader"
      principal_id                     = var.backup_vault_identity
      scope                            = var.aks_cluster_resource_group_id
      skip_service_principal_aad_check = true
    },
    "AKSCluster-Permission-In-Backup-RSG" = {
      role_definition_name             = "Contributor"
      principal_id                     = var.aks_system_assigned_identity
      scope                            = var.backup_storage_resource_group_id
      skip_service_principal_aad_check = true
    },
    "Backup-Extension-Permission-In-Backup-Storage" = {
      role_definition_name             = "Storage Account Contributor"
      principal_id                     = azurerm_kubernetes_cluster_extension.aks-backup-extension.aks_assigned_identity[0].principal_id
      scope                            = var.backup_storage_id
      skip_service_principal_aad_check = true
    },
    "BackupVault-MSI-SnapshotContributorOn-BackupStorageAccount-ResourceGroup" = {
      role_definition_name             = "Disk Snapshot Contributor"
      principal_id                     = var.backup_vault_identity
      scope                            = var.backup_storage_resource_group_id
      skip_service_principal_aad_check = true
    },
    "BackupVault-DataOperatorOn-BackupStorageAccount-ResourceGroup" = {
      role_definition_name             = "Data Operator for Managed Disks"
      principal_id                     = var.backup_vault_identity
      scope                            = var.backup_storage_id
      skip_service_principal_aad_check = true
    },
    "BackupVault-DataContributorOn-BackupStorageAccount" = {
      role_definition_name             = "Storage Blob Data Contributor"
      principal_id                     = var.backup_vault_identity
      scope                            = var.backup_storage_id
      skip_service_principal_aad_check = true
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.aks-backup-extension
  ]
}
resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "main" {
  count                           = var.create_backup_policy ? 1 : 0
  name                            = var.backup_policy_configuration.name
  resource_group_name             = var.backup_policy_configuration.backup_policy_resource_group_name
  vault_name                      = var.backup_policy_configuration.backup_vault_name
  backup_repeating_time_intervals = var.backup_policy_configuration.backup_repeating_time_intervals
  time_zone                       = var.backup_policy_configuration.time_zone
  #default_retention_duration      = var.backup_policy_configuration.default_retention_duration (Will be added after this issue has been resolved: https://github.com/hashicorp/terraform-provider-azurerm/issues/24887)

  default_retention_rule {
    life_cycle {
      duration        = "P7D"
      data_store_type = "OperationalStore"
    }
  }

  dynamic "retention_rule" {
    for_each = var.backup_policy_configuration.retention_rules
    content {
      name     = retention_rule.value.name
      priority = retention_rule.value.priority

      life_cycle {
        duration        = retention_rule.value.life_cycle.duration
        data_store_type = retention_rule.value.life_cycle.data_store_type
      }

      criteria {
        absolute_criteria      = retention_rule.value.criteria.absolute_criteria
        days_of_week           = retention_rule.value.criteria.days_of_week
        months_of_year         = retention_rule.value.criteria.months_of_year
        scheduled_backup_times = retention_rule.value.criteria.scheduled_backup_times
        weeks_of_month         = retention_rule.value.criteria.weeks_of_month
      }
    }
  }
}
resource "azurerm_data_protection_backup_instance_kubernetes_cluster" "main" {
  name                         = var.backup_instance_name
  location                     = var.location
  vault_id                     = var.backup_vault_id
  kubernetes_cluster_id        = var.aks_cluster_id
  snapshot_resource_group_name = var.backup_vault_resource_group
  backup_policy_id             = var.create_backup_policy ? azurerm_data_protection_backup_policy_kubernetes_cluster.main[0].id : var.backup_vault_aks_policy_id

  dynamic "backup_datasource_parameters" {
    for_each = var.backup_datasource_parameters != null ? [var.backup_datasource_parameters] : []
    content {
      excluded_namespaces              = backup_datasource_parameters.value.excluded_namespaces
      excluded_resource_types          = backup_datasource_parameters.value.excluded_resource_types
      cluster_scoped_resources_enabled = backup_datasource_parameters.value.cluster_scoped_resources_enabled
      included_namespaces              = backup_datasource_parameters.value.included_namespaces
      included_resource_types          = backup_datasource_parameters.value.included_resource_types
      label_selectors                  = backup_datasource_parameters.value.label_selectors
      volume_snapshot_enabled          = backup_datasource_parameters.value.volume_snapshot_enabled
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.aks-backup-extension,
    module.vault01-permissions
  ]
}
