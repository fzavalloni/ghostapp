terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = ">= 3.69.0"
  }
}
resource "azurerm_storage_account" "main" {
  name                              = var.storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  access_tier                       = var.account_kind == "BlockBlobStorage" && var.account_tier == "Premium" ? null : var.access_tier // Unset if premium. Not applicable to those account types.
  account_tier                      = var.account_tier
  account_kind                      = var.account_kind
  account_replication_type          = var.account_replication_type
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  allowed_copy_scope                = var.allowed_copy_scope
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  edge_zone                         = var.edge_zone
  enable_https_traffic_only         = var.nfsv3_enabled ? false : var.https_traffic_only_enabled // Unset if nfsv3. Uses additional ports 111/2048. https://learn.microsoft.com/en-us/azure/storage/blobs/network-file-system-protocol-support
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  is_hns_enabled                    = var.nfsv3_enabled || var.sftp_enabled ? true : var.hns_enabled // Set for sfpt/nfsv3. Hierarchical name system.  
  large_file_share_enabled          = var.large_file_share_enabled
  local_user_enabled                = var.local_user_enabled
  min_tls_version                   = var.min_tls_version
  nfsv3_enabled                     = var.nfsv3_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  queue_encryption_key_type         = var.queue_encryption_key_type
  sftp_enabled                      = var.sftp_enabled
  shared_access_key_enabled         = var.shared_access_key_enabled
  table_encryption_key_type         = var.table_encryption_key_type
  dns_endpoint_type                 = var.dns_endpoint_type
  tags                              = var.tags

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids == "UserAssigned" ? var.identity_ids : null
    }
  }

  dynamic "static_website" {
    for_each = var.static_website_config == null ? [] : ["enabled"]
    content {
      index_document     = var.static_website_config.index_document
      error_404_document = var.static_website_config.error_404_document
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain_name != null ? ["enabled"] : []
    content {
      name          = var.custom_domain_name
      use_subdomain = var.use_subdomain
    }
  }

  dynamic "blob_properties" {
    for_each = (
      var.account_kind != "FileStorage" && (var.storage_blob_data_protection != null || var.storage_blob_cors_rule != null) ? ["enabled"] : []
    )

    content {
      change_feed_enabled      = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.change_feed_enabled
      versioning_enabled       = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.versioning_enabled
      last_access_time_enabled = var.nfsv3_enabled || var.sftp_enabled ? false : var.storage_blob_data_protection.last_access_time_enabled

      dynamic "cors_rule" {
        for_each = var.storage_blob_cors_rule != null ? ["enabled"] : []
        content {
          allowed_headers    = var.storage_blob_cors_rule.allowed_headers
          allowed_methods    = var.storage_blob_cors_rule.allowed_methods
          allowed_origins    = var.storage_blob_cors_rule.allowed_origins
          exposed_headers    = var.storage_blob_cors_rule.exposed_headers
          max_age_in_seconds = var.storage_blob_cors_rule.max_age_in_seconds
        }
      }

      delete_retention_policy {
        days                     = var.storage_blob_data_protection.delete_retention_policy_in_days
        permanent_delete_enabled = var.storage_blob_data_protection.permanent_delete_enabled
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.storage_blob_data_protection.container_delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days
        }
      }

      dynamic "restore_policy" {
        for_each = local.pitr_enabled ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days - 1
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties_logging != null && contains(["Storage", "StorageV2"], var.account_kind) ? ["enabled"] : []
    content {
      logging {
        delete                = var.queue_properties_logging.delete
        read                  = var.queue_properties_logging.read
        write                 = var.queue_properties_logging.write
        version               = var.queue_properties_logging.version
        retention_policy_days = var.queue_properties_logging.retention_policy_days
      }
    }
  }

  dynamic "share_properties" {
    for_each = var.file_share_cors_rules != null || var.file_share_retention_policy_in_days != null || var.file_share_properties_smb != null ? ["enabled"] : []
    content {
      dynamic "cors_rule" {
        for_each = var.file_share_cors_rules != null ? ["enabled"] : []
        content {
          allowed_headers    = var.file_share_cors_rules.allowed_headers
          allowed_methods    = var.file_share_cors_rules.allowed_methods
          allowed_origins    = var.file_share_cors_rules.allowed_origins
          exposed_headers    = var.file_share_cors_rules.exposed_headers
          max_age_in_seconds = var.file_share_cors_rules.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = var.file_share_retention_policy_in_days != null ? ["enabled"] : []
        content {
          days = var.file_share_retention_policy_in_days
        }
      }

      dynamic "smb" {
        for_each = var.file_share_properties_smb != null ? ["enabled"] : []
        content {
          authentication_types            = var.file_share_properties_smb.authentication_types
          channel_encryption_type         = var.file_share_properties_smb.channel_encryption_type
          kerberos_ticket_encryption_type = var.file_share_properties_smb.kerberos_ticket_encryption_type
          versions                        = var.file_share_properties_smb.versions
          multichannel_enabled            = var.file_share_properties_smb.multichannel_enabled
        }
      }
    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.file_share_authentication != null ? ["enabled"] : []
    content {
      directory_type = var.file_share_authentication.directory_type
      dynamic "active_directory" {
        for_each = var.file_share_authentication.directory_type == "AD" ? [var.file_share_authentication.active_directory] : []
        iterator = ad
        content {
          storage_sid         = ad.value.storage_sid
          domain_name         = ad.value.domain_name
          domain_sid          = ad.value.domain_sid
          domain_guid         = ad.value.domain_guid
          forest_name         = ad.value.forest_name
          netbios_domain_name = ad.value.netbios_domain_name
        }
      }
    }
  }

  # Bug when nfsv3 is activated. The external resource azurerm_storage_account_network_rules is not taken into account
  dynamic "network_rules" {
    for_each = var.nfsv3_enabled ? ["enabled"] : []
    content {
      default_action             = "Deny"
      bypass                     = var.network_bypass
      ip_rules                   = local.storage_ip_rules
      virtual_network_subnet_ids = var.subnet_ids
      dynamic "private_link_access" {
        for_each = var.private_link_access
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Storage Containers
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_storage_container" "this_container" {
  #checkov:skip=CKV2_AZURE_21:Ensure Storage logging is enabled for Blob service for read requests.  Not applicable because we use Azure Policy to set it
  for_each              = try({ for i in var.containers : i.name => i }, {})
  name                  = each.key
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata

  depends_on = [
    azurerm_storage_account.main
  ]
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Storage File Shares
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_storage_share" "this_share" {
  for_each             = try({ for i in var.file_shares : i.name => i }, {})
  name                 = each.key
  storage_account_name = azurerm_storage_account.main.name
  quota                = each.value.quota_in_gb
  enabled_protocol     = each.value.enabled_protocol
  metadata             = each.value.metadata

  dynamic "acl" {
    for_each = each.value.acl != null ? each.value.acl : []

    content {
      id = acl.value.id

      access_policy {
        permissions = acl.value.permissions
        start       = acl.value.start
        expiry      = acl.value.expiry
      }
    }
  }

  lifecycle {
    precondition {
      condition     = each.value.enabled_protocol == "NFS" ? var.account_tier == "Premium" : true
      error_message = "NFS file shares can only be enabled on Premium Storage Accounts."
    }
    precondition {
      condition     = var.account_tier != "Premium" || each.value.quota_in_gb >= 100
      error_message = "File share quota must be at least 100Gb for Premium Storage Accounts."
    }
  }
}
resource "azurerm_storage_table" "this_table" {
  for_each             = try({ for i in var.tables : i.name => i }, {})
  name                 = each.key
  storage_account_name = azurerm_storage_account.main.name
}
resource "azurerm_storage_queue" "this_queue" {
  for_each             = try({ for i in var.queues : i.name => i }, {})
  storage_account_name = azurerm_storage_account.main.name
  name                 = each.key
  metadata             = each.value.metadata
}
resource "azurerm_storage_account_network_rules" "network_rules" {
  for_each                   = toset(var.network_rules_enabled && !var.nfsv3_enabled ? ["enabled"] : [])
  storage_account_id         = azurerm_storage_account.main.id
  default_action             = var.default_firewall_action
  bypass                     = var.network_bypass
  ip_rules                   = local.storage_ip_rules
  virtual_network_subnet_ids = var.default_firewall_action == "Deny" ? var.subnet_ids : []
  dynamic "private_link_access" {
    for_each = var.private_link_access
    content {
      endpoint_resource_id = private_link_access.value.endpoint_resource_id
      endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  The provider version AzureRm 3.81 still doesn't have implementation of the Storage Default Permission, so we need to workaround it through 
  Powershell commands. 
  Only executes it through the Azure Devops Build Agent, because it depends on certain tools that might not be installed in your local computer.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Sets the File Share Authentication type
  
  Notice
  
  1.  Every time we install or update the storage account, the trigger goes off and execute these Powershell commands
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "null_resource" "azurerm_storage_account_smb_default_share_permissions" {
  count = try(var.file_share_authentication.directory_type, null) == "AD" ? 1 : 0
  triggers = {
    storage = azurerm_storage_account.main.id
  }

  provisioner "local-exec" {
    command     = <<-EOT
      Write-Output "Load PowerShell Modules"
      $ErrorActionPreference = 'Stop'

      $modules = @("Az.Storage")
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
        Write-Output "Connect to the subscription"
        Connect-AzAccount -ServicePrincipal -Credential $credObject -TenantId $tenantId -SubscriptionId $subscriptionId
      }
      catch
      {
        Write-Output "Failed to connect on Azure Portal. Trying with the local credentials...."        
      }

      $storageName = "${azurerm_storage_account.main.name}"
      $resourceGroupName = "${var.resource_group_name}"
      $storage = Get-AzStorageAccount -Name $storageName -ResourceGroupName $resourceGroupName
      $existingDefaultSharePermission = $storage.AzureFilesIdentityBasedAuth.DefaultSharePermission
      $desiredDefaultSharePermission = "${var.file_share_default_share_permission}"
      
      if($existingDefaultSharePermission -ne $desiredDefaultSharePermission)
      {
        Write-Output "Set the DefaultStoragePermission to [$desiredDefaultSharePermission] in the storage [$storageName]"
        Set-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageName -DefaultSharePermission $desiredDefaultSharePermission
      }
      else
      {
        Write-Output "The DefaultSharePermission is already set to [$desiredDefaultSharePermission].....Skipping....[Nothing to do] "
      }      
      
    EOT
    interpreter = ["PowerShell", "-Command"]
  }

  depends_on = [
    azurerm_storage_account.main
  ]
}
resource "azurerm_data_protection_backup_policy_blob_storage" "backup_policy" {
  count              = var.create_backup_policy ? 1 : 0
  name               = var.backup_policy_name
  vault_id           = var.backup_vault_id
  retention_duration = var.backup_retention_duration
}
resource "azurerm_data_protection_backup_instance_blob_storage" "backup_instance" {
  count              = var.create_backup_instance ? 1 : 0
  name               = var.backup_instance_name
  location           = var.location
  vault_id           = var.backup_vault_id
  storage_account_id = azurerm_storage_account.main.id
  backup_policy_id   = var.create_backup_policy ? azurerm_data_protection_backup_policy_blob_storage.backup_policy[0].id : var.backup_policy_id

}
