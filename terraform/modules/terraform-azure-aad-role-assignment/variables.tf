variable "assignments" {
  description = "(Required) A map of role assignments."
  type = map(object({
    principal_id                     = string
    role_definition_name             = string
    scope                            = string
    skip_service_principal_aad_check = bool
  }))
  nullable = false
}