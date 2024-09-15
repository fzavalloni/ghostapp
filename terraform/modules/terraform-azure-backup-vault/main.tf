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
  - Resource block to create a Data Protection Backup vault.
  - Resource block to create a Data Protection Backup Policy Blob Storage.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create a Data Protection Backup vault.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_data_protection_backup_vault" "this" {
  name                       = var.vault_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  datastore_type             = var.datastore_type
  redundancy                 = var.redundancy
  retention_duration_in_days = var.retention_duration_in_days
  soft_delete                = var.soft_delete
  tags                       = var.tags

  identity {
    type = var.identity_type
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create a Data Protection Backup Policy Blob Storage.
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_data_protection_backup_policy_blob_storage" "this" {
  for_each           = var.backup_policies
  name               = each.value.name
  vault_id           = azurerm_data_protection_backup_vault.this.id
  retention_duration = each.value.retention_duration
}
