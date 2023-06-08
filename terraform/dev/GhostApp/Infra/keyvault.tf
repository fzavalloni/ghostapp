data "azuread_group" "mgmt-group" {
  display_name     = "Global-Administrators"
  security_enabled = true
}

module "kv001" {
  source              = "../../../modules/terraform-azure-keyvault"
  
  name                = "${var.environment-prefix}KV01"
  resource_group_name = module.resource-group-01.name
  location            = var.location
  access_policies = [
    {
      object_ids = [module.akscluster01.kubelet_identity]
      secret_permissions = ["Get", "List", "Set"]
      key_permissions = ["Create", "Get", "List", "Update"]
      certificate_permissions = ["Create", "Get", "List", "Update"]
    },
    {
      object_ids = [module.akscluster01.system_assigned_identity]
      secret_permissions = ["Get", "List", "Set"]
      key_permissions = ["Create", "Get", "List", "Update"]
      certificate_permissions = ["Create", "Get", "List", "Update"]
    },
    {
      object_ids = [data.azuread_group.mgmt-group.object_id]
      secret_permissions = ["Get", "List", "Set"]
      key_permissions = ["Create", "Get", "List", "Update"]
      certificate_permissions = ["Create", "Get", "List", "Update"]
    },
  ]

  depends_on = [
    module.akscluster01,
    module.resource-group-01
  ]
}