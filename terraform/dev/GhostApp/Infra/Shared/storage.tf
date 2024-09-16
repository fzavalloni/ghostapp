module "storage_shared_01" {
  source = "../../../../modules/terraform-azure-storage"

  storage_account_name    = "ghostappsharedstorage01"
  resource_group_name     = module.shared-resource-group.name
  location                = var.location
  network_rules_enabled   = true
  default_firewall_action = "Allow"

  containers = [
    {
      name        = "akscluster"
      access_type = "private"
    }
  ]
}