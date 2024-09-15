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