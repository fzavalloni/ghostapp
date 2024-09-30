module "backup-vault01" {
  source              = "../../../../modules/terraform-azure-backup-vault"
  vault_name          = "${var.environment-prefix}Vault01"
  resource_group_name = module.resource-group-01.name
  location            = var.location
  identity_type       = "SystemAssigned"

  backup_policies = {
    weeklyretention = {
      name               = "BackupPolicyRetention7Days"
      retention_duration = "P7D"
    }
  }
}

# module "akscluster01-backup" {
#   source                           = "../../../../modules/terraform-azure-aks-backup"
#   backup_instance_name             = module.akscluster01.name
#   aks_cluster_id                   = module.akscluster01.aks_id
#   aks_system_assigned_identity     = module.akscluster01.system_assigned_identity
#   aks_cluster_resource_group_id    = module.resource-group-01.id
#   location                         = var.location
#   backup_storage_name              = data.terraform_remote_state.shared.outputs.shared_storage01_name
#   backup_storage_id                = data.terraform_remote_state.shared.outputs.shared_storage01_id
#   backup_storage_resource_group    = data.terraform_remote_state.shared.outputs.shared_resource_group_name
#   backup_storage_resource_group_id = data.terraform_remote_state.shared.outputs.shared_resource_group_id
#   backup_storage_container         = "akscluster"  
#   backup_vault_resource_group      = module.backup-vault01.backup_vault_resource_group_name
#   backup_vault_id                  = module.backup-vault01.backup_vault_id
#   backup_vault_identity            = module.backup-vault01.identity
#   create_backup_policy             = true
#   backup_policy_configuration = {
#     name                              = "AKS-backup-policy"
#     backup_policy_resource_group_name = module.backup-vault01.backup_vault_resource_group_name
#     backup_vault_name                 = module.backup-vault01.backup_vault_name
#     backup_repeating_time_intervals   = ["daily"]
#     time_zone                         = "UTC"
#     retention_rules = [
#       {
#         name     = "weekly-retention"
#         priority = 1
#         life_cycle = {
#           duration        = "P4M"
#           data_store_type = "OperationalStore"
#         }
#         criteria = {
#           absolute_criteria      = "FirstOfDay"
#           days_of_week           = ["Monday"]
#           months_of_year         = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
#           scheduled_backup_times = ["2024-09-22T15:30:45+02:00"]
#           weeks_of_month         = ["Last"]
#         }
#       }
#     ]
#   }
#   subscription_id                  = var.subs_id
#   tenant_id                        = var.tenant_id

#   depends_on = [
#     module.akscluster01,
#     module.backup-resource-group
#   ]
# }