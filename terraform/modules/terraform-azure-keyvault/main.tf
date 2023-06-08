data "azuread_group" "main" {
  count = length(local.group_names)
  display_name  = local.group_names[count.index]
}

data "azuread_user" "main" {
  count               = length(local.user_principal_names)
  user_principal_name = local.user_principal_names[count.index]
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_client_config" "main" {}

resource "azurerm_key_vault" "main" {
  #checkov:skip=CKV_AZURE_109:We cannot implement due backward compatibility
  #checkov:skip=CKV2_AZURE_32:Not applicable within this resource
  name                = var.name
  location            = var.location == "" ? data.azurerm_resource_group.main.location : var.location
  resource_group_name = data.azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.main.tenant_id
  sku_name            = var.sku

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  enable_rbac_authorization       = var.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    iterator = acl

    content {
      bypass                     = acl.value.bypass
      default_action             = acl.value.default_action
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
    }
  }

  dynamic "access_policy" {
    for_each = local.combined_access_policies

    content {
      tenant_id = data.azurerm_client_config.main.tenant_id
      object_id = access_policy.value.object_id

      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }

  dynamic "access_policy" {
    for_each = local.service_principal_object_id != "" ? [local.self_permissions] : []

    content {
      tenant_id = data.azurerm_client_config.main.tenant_id
      object_id = access_policy.value.object_id

      key_permissions    = access_policy.value.key_permissions
      secret_permissions = access_policy.value.secret_permissions
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "main" {
  #checkov:skip=CKV_AZURE_114:Content check is severity low
  #checkov:skip=CKV_AZURE_41:We don't use it at the moment in our environment
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id
}