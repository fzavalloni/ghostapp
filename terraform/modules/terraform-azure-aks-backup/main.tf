#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Main
*/
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Sets Providers and Versions
*/
#------------------------------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Module Logic
  - Data block to fetch existing Subscription Information.
  - Data block to fetch existing Azure Kubernetes Cluster Information.
  - Data block to fetch existing Azure Backup Vault Information.
  - Data block to fetch existing Azure Kubernetes Cluster Resource Group.
  - Data block to fetch existing Azure Kubernetes Cluster Backup Resource Group.
  - Data block to fetch existing Azure Storage Account for this Azure Kubernetes Backup.
  - Resource block to create Azure Provider Registration for "Microsoft.KubernetesConfiguration".
  - Resource block to create Azure Kubernetes Cluster Extention for Azure Backup.
  - Resource block to create Azure Kubernetes Cluster RoleBinding for Azure Backup.
  - Module block to set RoleAssignment for Azure Kubernetes Cluster on Azure Backup Vault.
  - Resource block for null which triggers PowerShell as workaround for Configure the Backup on the Azure Kubernetes Cluster.
*/
#------------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Kubernetes Backup Provider Registration
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_resource_provider_registration" "this" {
  count = var.enable_kubernetes_configuration_provider ? 1 : 0
  name  = "Microsoft.KubernetesConfiguration"
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Kubernetes Cluster Extention for Backup
*/
#------------------------------------------------------------------------------------------------------------------------------------------
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
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Kubernetes Cluster Role Binding for Backup
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster_trusted_access_role_binding" "this" {
  kubernetes_cluster_id = var.aks_cluster_id
  name                  = "BackupVaultBind"
  roles                 = ["Microsoft.DataProtection/backupVaults/backup-operator"]
  source_resource_id    = var.backup_vault_id
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Role Assignment for AKS Cluster on Backup Vault
*/
#------------------------------------------------------------------------------------------------------------------------------------------
module "vault01-permissions" {
  source = "../terraform-azure-aad-role-assignment"

  assignments = {
    "BackupVault-Permission-In-AKSCluster" = {
      role_definition_name             = "Reader"
      principal_id                     = var.backup_vault_identity
      scope                            = var.aks_cluster_id
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
    "AKSCluster-Permission-In-Backup-Storage" = {
      role_definition_name             = "Contributor"
      principal_id                     = var.aks_system_assigned_identity
      scope                            = var.backup_storage_id
      skip_service_principal_aad_check = true
    },
    "Backup-Extension-Permission-In-Backup-Storage" = {
      role_definition_name             = "Storage Account Contributor"
      principal_id                     = azurerm_kubernetes_cluster_extension.aks-backup-extension.aks_assigned_identity[0].principal_id
      scope                            = var.backup_storage_id
      skip_service_principal_aad_check = true
    }
  }
  depends_on = [
    azurerm_kubernetes_cluster_extension.aks-backup-extension
  ]
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  The provider version AzureRm 3.69 still don't have any implmentation to the AKS Backup, so we need to workaround it through Powershell
  commands. Only executes it through the Azure Devops Build Agent, because it depends on certain tools that might not be installed in your 
  local computer.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Kubernetes Backup Provider Registration
  
  Notice
  
  1.  Every time we install or update the aks-backup-extension, the trigger goes off and execute these Powershell commands
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "null_resource" "azurerm_data_protection_backup_policy_aks" {

  triggers = {
    current_version = azurerm_kubernetes_cluster_extension.aks-backup-extension.current_version
  }

  provisioner "local-exec" {
    command     = <<-EOT
      Write-Output "Load PowerShell Modules"
      $ErrorActionPreference = 'Stop'

      $modules = @("Az.DataProtection","Az.Resources","Az.Aks")
      if($null -eq (Get-PackageProvider -Name NuGet -Ea Ignore))
      {
        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
      }

      foreach($module in $modules)
      {
        Install-Module -Name $module -Force -Verbose -Scope CurrentUser -AllowClobber      
        Import-Module $module
      }      
     
      Write-Output "Get the credentials (Service Connection) from the environment variables"
      $subscriptionId = $env:ARM_SUBSCRIPTION_ID
      $tenantId = $env:ARM_TENANT_ID
      $clientId = $env:ARM_CLIENT_ID
      $secret = $env:ARM_CLIENT_SECRET      

      try
      {
        [securestring]$secStringPassword = ConvertTo-SecureString $secret -AsPlainText -Force
        [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($clientId, $secStringPassword)
        Write-Output "Connect on Azure and run the command"
        Connect-AzAccount -ServicePrincipal -Credential $credObject -TenantId $tenantId -SubscriptionId $subscriptionId
      }
      catch
      {
        Write-Output "Failed to connect on Azure Portal. Trying with the local credentials...."
        Write-Output "If you are running it in your laptop, run this command first [Connect-AzAccount -SubscriptionName XXXXXXXXXXX]"
      }
      $policyName = "${var.backup_vault_aks_policy_name}"
      $existingPolicy = Get-AzDataProtectionBackupPolicy -VaultName ${var.backup_vault_name} -ResourceGroupName ${var.backup_vault_resource_group} -Name $policyName -ErrorAction SilentlyContinue

      if($null -eq $existingPolicy)
      {         
        Write-Output "Retrive the default policy definition"
        $policyDefn = Get-AzDataProtectionPolicyTemplate -DatasourceType AzureKubernetesService
        Write-Output "Create Policy Schedule"
        $schedule = New-AzDataProtectionPolicyTriggerScheduleClientObject -ScheduleDays $(Get-date) -IntervalType ${var.backup_vault_aks_policy_repeating_interval} -IntervalCount ${var.backup_vault_aks_policy_repeating_interval_count}
        Edit-AzDataProtectionPolicyTriggerClientObject -Policy $policyDefn -Schedule $schedule
        Write-Output "Create Policy Retention"
        $lifecycle = New-AzDataProtectionRetentionLifeCycleClientObject -SourceDataStore OperationalStore -SourceRetentionDurationType Weeks -SourceRetentionDurationCount ${var.backup_vault_aks_policy_retention_weeks}
        Edit-AzDataProtectionPolicyRetentionRuleClientObject -Policy $policyDefn -Name Default -LifeCycles $lifecycle -IsDefault $false
        Write-Output "Create Policy [$policyName]"
        New-AzDataProtectionBackupPolicy -ResourceGroupName "${var.backup_vault_resource_group}" -VaultName "${var.backup_vault_name}" -Name $policyName -Policy $policyDefn
      }
      else
      {
        Write-Output "Policy already exists. [Skipping.....nothing to be done]"
      }

      Write-Output "Configure AKS Backup"
      $existingBkpPolicy = Get-AzDataProtectionBackupInstance -ResourceGroupName "${var.backup_vault_resource_group}" -VaultName ${var.backup_vault_name} | Where-Object{$_.Name.contains("${var.aks_cluster_name}")}
      if($null -eq $existingBkpPolicy)
      {
        $sourceClusterId = "${var.aks_cluster_id}"
        $snapshotResourceGroupId = (Get-AzResourceGroup -Name "${var.backup_vault_resource_group}").ResourceId         
        $policy = Get-AzDataProtectionBackupPolicy -VaultName ${var.backup_vault_name} -ResourceGroupName ${var.backup_vault_resource_group} -Name $policyName        
        $backupConfig = New-AzDataProtectionBackupConfigurationClientObject -SnapshotVolume $true -IncludeClusterScopeResource $true -DatasourceType AzureKubernetesService
        $backupInstance = Initialize-AzDataProtectionBackupInstance -DatasourceType AzureKubernetesService -DatasourceLocation "${var.location}" -PolicyId $policy.Id -DatasourceId $sourceClusterId -SnapshotResourceGroupId $snapshotResourceGroupId -FriendlyName "${var.aks_cluster_name}" -BackupConfiguration $backupConfig
        Write-Output "Apply MSI Permission"
        Set-AzDataProtectionMSIPermission -BackupInstance $backupInstance -VaultResourceGroup "${var.backup_vault_resource_group}" -VaultName "${var.backup_vault_name}" -PermissionsScope "ResourceGroup" -Confirm:$false
        Write-Output "Validate the Backup Rediness"
        Test-AzDataProtectionBackupInstanceReadiness -ResourceGroupName "${var.backup_vault_resource_group}" -VaultName ${var.backup_vault_name} -BackupInstance  $backupInstance.Property
        Write-Output "Create Backup Policy"
        New-AzDataProtectionBackupInstance -ResourceGroupName "${var.backup_vault_resource_group}" -VaultName ${var.backup_vault_name} -BackupInstance $backupInstance
      }
      else
      {
        Write-Output "Backup is already configured. [Skipping.....nothing to be done]"
      }
      
    EOT
    interpreter = ["PowerShell", "-Command"]
  }

  depends_on = [
    azurerm_kubernetes_cluster_extension.aks-backup-extension,
    module.vault01-permissions
  ]
}
