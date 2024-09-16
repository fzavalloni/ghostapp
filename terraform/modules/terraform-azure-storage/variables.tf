variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Storage Account."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Storage Account."
  type        = string
  nullable    = false
}
variable "storage_account_name" {
  description = "(Required) The name to assign to this Azure Storage Account."
  type        = string
  nullable    = false
}
variable "account_kind" {
  description = "(Optional) Defines the kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created. Defaults to `StorageV2`."
  type        = string
  default     = "StorageV2"
}
variable "account_tier" {
  description = "(Optional) Defines the tier to use for this Storage Account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created. Defaults to `Standard`."
  type        = string
  default     = "Standard"
}
variable "access_tier" {
  description = "(Optional) Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`. Defaults to `Hot`."
  type        = string
  default     = "Hot"
}
variable "account_replication_type" {
  description = "(Optional) Defines the type of replication to use for this Storage Account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. Defaults to `LRS`."
  type        = string
  default     = "LRS"
}
variable "https_traffic_only_enabled" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled. Defaults to `true`."
  type        = bool
  default     = true
}
variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the Storage Account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_2`."
  type        = string
  default     = "TLS1_2"
}
variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to `false`."
  type        = bool
  default     = false
}
variable "allowed_copy_scope" {
  description = "(Optional) Set copy operations to be restricted to one of `AAD` or `PrivateLink` . Defaults to `null`."
  type        = string
  default     = null
}
variable "cross_tenant_replication_enabled" {
  description = "(Optional) Should cross tenant replication be enabled? Defaults to `true`."
  type        = bool
  default     = true
}
variable "custom_domain_name" {
  description = "(Optional) The custom domain name to use for the Storage Account, which will be validated by Azure. Defaults to `null`."
  type        = string
  default     = null
}
variable "use_subdomain" {
  description = "(Optional) Should the custom domain name be validated by using indirect CNAME validation? Defaults to `false`."
  type        = bool
  default     = false
}
variable "static_website_config" {
  description = "(Optional) Static website configuration. Can only be set when the `account_kind` is set to `StorageV2` or `BlockBlobStorage`. Defaults to `null`."
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}
variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the Storage Account permits requests to be authorized with the account access key via shared key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). Default to `true`."
  type        = bool
  default     = true
}
variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false
}
variable "sftp_enabled" {
  description = "(Optional) Is SFTP enabled? Defaults to `false`."
  type        = bool
  default     = false
}
variable "dns_endpoint_type" {
  description = "(Optional) Specifies which DNS endpoint type to use. Possible values are Standard and AzureDnsZone. Defaults to 'Standard'. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"
}
variable "hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 and must be `true` if `nfsv3_enabled` or `sftp_enabled` is set to `true`. Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false
}
variable "default_to_oauth_authentication" {
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is `false`"
  type        = bool
  default     = false
}
variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created. Defaults to `null`."
  type        = string
  default     = null
}
variable "infrastructure_encryption_enabled" {
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false
}
variable "large_file_share_enabled" {
  description = "(Optional) Is Large File Share Enabled? Defaults to `false`."
  type        = bool
  default     = false
}
variable "local_user_enabled" {
  description = "(Optional) Is Local User Enabled? Defaults to `true`."
  type        = bool
  default     = true
}
variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled? Defaults to `true`."
  type        = bool
  default     = true
}
variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`."
  type        = string
  default     = "Service"
}
variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the table service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`."
  type        = string
  default     = "Service"
}
variable "identity_type" {
  description = "(Optional) Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). Defaults to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}
variable "identity_ids" {
  description = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. Defaults to `null`."
  type        = list(string)
  default     = null
}
variable "storage_blob_data_protection" {
  description = "(Optional) Storage account blob Data protection parameters. Defaults to `30 Day Policy`"
  type = object({
    change_feed_enabled                       = optional(bool, false)
    versioning_enabled                        = optional(bool, false)
    last_access_time_enabled                  = optional(bool, false)
    delete_retention_policy_in_days           = optional(number, 0)
    permanent_delete_enabled                  = optional(bool, false)
    container_delete_retention_policy_in_days = optional(number, 0)
    container_point_in_time_restore           = optional(bool, false)
  })
  default = {
    change_feed_enabled                       = true
    last_access_time_enabled                  = true
    versioning_enabled                        = true
    delete_retention_policy_in_days           = 30
    container_delete_retention_policy_in_days = 30
    container_point_in_time_restore           = true
    permanent_delete_enabled                  = false
  }
}
variable "storage_blob_cors_rule" {
  description = "Storage Account blob CORS rule. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information. Defaults to `null`."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}
variable "containers" {
  description = "(Optional) List of objects to create Blob Containers in this Storage Account. Defaults to `[]`."
  type = list(object({
    name                  = string
    container_access_type = optional(string, "private")
    metadata              = optional(map(string))
  }))
  default = []
}
variable "file_shares" {
  description = "(Optional) List of objects to create File Shares in this Storage Account. Defaults to `[]`."
  type = list(object({
    name             = string
    quota_in_gb      = number
    enabled_protocol = optional(string)
    metadata         = optional(map(string))
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}
variable "tables" {
  description = "(Optional) List of objects to create Tables in this Storage Account. Defaults to `[]`."
  type = list(object({
    name = string
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}
variable "queues" {
  description = "(Optional) List of objects to create some Queues in this Storage Account. Defaults to `[]`."
  type = list(object({
    name     = string
    metadata = optional(map(string))
  }))
  default = []
}
variable "queue_properties_logging" {
  description = "(Optional) Logging queue properties. Defaults to `{}`."
  type = object({
    delete                = optional(bool, true)
    read                  = optional(bool, true)
    write                 = optional(bool, true)
    version               = optional(string, "1.0")
    retention_policy_days = optional(number, 10)
  })
  default = {}
}
variable "file_share_cors_rules" {
  description = "Storage Account file shares CORS rule. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}
variable "file_share_retention_policy_in_days" {
  description = "Storage Account file shares retention policy in days. Enabling this may require additional directory permissions."
  type        = number
  default     = null
}
variable "file_share_properties_smb" {
  description = "Storage Account file shares smb properties."
  type = object({
    versions                        = optional(list(string), null)
    authentication_types            = optional(list(string), null)
    kerberos_ticket_encryption_type = optional(list(string), null)
    channel_encryption_type         = optional(list(string), null)
    multichannel_enabled            = optional(bool, null)
  })
  default = null
}
variable "file_share_authentication" {
  description = "Storage Account file shares authentication configuration."
  type = object({
    directory_type = string
    active_directory = optional(object({
      storage_sid         = string
      domain_name         = string
      domain_sid          = string
      domain_guid         = string
      forest_name         = string
      netbios_domain_name = string
    }))
  })
  default = null

  validation {
    condition = var.file_share_authentication == null || (
      contains(["AADDS", "AD", ""], try(var.file_share_authentication.directory_type, ""))
    )
    error_message = "`file_share_authentication.directory_type` can only be `AADDS` or `AD`."
  }
  validation {
    condition = var.file_share_authentication == null || (
      try(var.file_share_authentication.directory_type, null) == "AADDS" || (
        try(var.file_share_authentication.directory_type, null) == "AD" &&
        try(var.file_share_authentication.active_directory, null) != null
      )
    )
    error_message = "`file_share_authentication.active_directory` block is required when `file_share_authentication.directory_type` is set to `AD`."
  }
}
variable "file_share_default_share_permission" {
  description = "(Optional)  Default share permission for users using Kerberos authentication (Active Directory)"
  default     = "StorageFileDataSmbShareElevatedContributor"
  validation {
    condition = (
      contains(["StorageFileDataSmbShareContributor", "StorageFileDataSmbShareReader", "StorageFileDataSmbShareElevatedContributor"], try(var.file_share_default_share_permission, ""))
    )
    error_message = "`file_share_default_share_permission` can only be `StorageFileDataSmbShareContributor` or `StorageFileDataSmbShareReader` or `StorageFileDataSmbShareElevatedContributor`."
  }
}
variable "network_rules_enabled" {
  description = "(Optional) Boolean to enable Network Rules on the Storage Account, requires `network_bypass`, `allowed_cidrs`, `subnet_ids` or `default_firewall_action` correctly set if enabled. Defaults to `true`."
  type        = bool
  default     = true
}
variable "network_bypass" {
  description = "(Optional) Specifies whether traffic is bypassed for 'Logging', 'Metrics', 'AzureServices' or 'None'. Defaults to `All`."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]
}
variable "allowed_cidrs" {
  description = "(Optional) List of CIDR to allow access to that Storage Account. Defaults to `[]`."
  type        = list(string)
  default     = []
}
variable "subnet_ids" {
  description = "(Optional) Subnets to allow access to that Storage Account. Defaults to `[]`."
  type        = list(string)
  default     = []
}
variable "default_firewall_action" {
  description = "(Optional) Which default firewalling policy to apply. Valid values are `Allow` or `Deny`. Defaults to `Deny`."
  type        = string
  default     = "Deny"
}
variable "private_link_access" {
  description = "(Optional) List of Privatelink objects to allow access from. Defaults to `[]`."
  type = list(object({
    endpoint_resource_id = string
    endpoint_tenant_id   = optional(string, null)
  }))
  default  = []
  nullable = false
}
variable "create_backup_role_assignment" {
  description = "(Required) Whether to assign role to backup vault and blob storage?"
  type        = bool
  default     = false
}
variable "backup_vault_identity" {
  description = "(Optional) The Azure Backup Vault managed Identity that controls the Blob storage Backup"
  type        = string
  default     = null
}
variable "create_backup_policy" {
  description = "(Required) Whether to create the backup policy."
  type        = bool
  default     = false
}
variable "backup_policy_name" {
  description = "(Required) The name which should be used for this Backup Policy Blob Storage. Changing this forces a new Backup Policy Blob Storage to be created."
  type        = string
  default     = "BlobBackupPolicy"
}
variable "backup_vault_id" {
  description = "(Optional) The ID of the Backup Vault within which the Backup Policy Blob Storage should exist. Changing this forces a new Backup Policy Blob Storage to be created."
  type        = string
  default     = null
}
variable "backup_retention_duration" {
  description = "(Required) Duration of deletion after given timespan. It should follow ISO 8601 duration format. Changing this forces a new Backup Policy Blob Storage to be created."
  type        = string
  default     = "P30D"
}
variable "create_backup_instance" {
  description = "(Required) Whether to create the Backup Instance Blob Storage?"
  type        = bool
  default     = false
}
variable "backup_instance_name" {
  description = "(Required) The name which should be used for this Backup Instance Blob Storage."
  type        = string
  default     = "BlobStorageBackupInstance"
}
variable "backup_policy_id" {
  description = "(Optional) The ID of the Backup Policy."
  type        = string
  default     = null
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
