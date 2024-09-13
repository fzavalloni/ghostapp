data "azuread_users" "admin" {
  user_principal_names = ["fzavalloni_hotmail.com#EXT#@fzavallonihotmail.onmicrosoft.com"]
}

module "grafana_admin_group" {
  source = "../../../../modules/terraform-azure-aad-group"

  display_name = "Grafana-Admin-Users"
  description  = "Azure AD - Grafana Administrators Group"
  members      = data.azuread_users.admin.object_ids
}

module "azure_ad_assignments"{
   source = "../../../../modules/terraform-azure-aad-role-assignment"

   assignments = {
    Grafana = {
      principal_id                     = module.grafana01.identity_principal_id
      role_definition_name             = "Monitoring Reader"
      scope                            = module.resource-group-01.id
      skip_service_principal_aad_check = true
    },
    GrafanaAdminGroup = {
      principal_id                     = module.grafana_admin_group.group_id
      role_definition_name             = "Grafana Admin"
      scope                            = module.grafana01.instance_id
      skip_service_principal_aad_check = false
    }
   }
}