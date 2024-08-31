variable "kubeconfig" {
  description = "(Required) Authentication for K8s Config."
  type        = string
  nullable    = false
}
variable "release" {
  description = <<EOT
  (Required) List application to deploy. Defaults to `{}`.

  Example Inputs
  ```hcl
  release = {
  // Helm Chart: Certificate Manager
    cert-manager = {
      repository_name     = "cert-manager"
      namespace           = "cert-manager"
      chart               = "cert-manager"
      repository          = "https://charts.jetstack.io"
      repository_username = null
      repository_password = null
      version             = "v1.13.0"
      verify              = false
      reuse_values        = false
      reset_values        = false
      force_update        = true
      timeout             = 3600
      recreate_pods       = false
      max_history         = 200
      wait                = true
      create_namespace    = true
      values              = null
      set = [
        {
          name  = "installCRDs"
          value = "true"
        }
      ]
    }
    // Helm Chart: a365-portainer-agent
    portainer-agent = {
      repository_name     = "portainer-agent"
      namespace           = "portainer"
      chart               = "portainer-agent"
      repository          = var.acr_default_registry_in_tenant_fqdn
      repository_username = var.acr_default_registry_in_tenant_username
      repository_password = var.acr_default_registry_in_tenant_password
      version             = "v1.0.0"
      verify              = false
      reuse_values        = false
      reset_values        = false
      force_update        = true
      timeout             = 3600
      recreate_pods       = false
      max_history         = 200
      wait                = true
      create_namespace    = true
      values              = null
    }
  }
  ```
  EOT
  type = map(object({
    repository_name            = string
    chart                      = string
    description                = optional(string)
    render_subchart_notes      = optional(bool)
    repository                 = optional(string)
    repository_username        = optional(string)
    repository_password        = optional(string)
    version                    = optional(string)
    verify                     = optional(bool)
    timeout                    = optional(number)
    reuse_values               = optional(bool)
    reset_values               = optional(bool)
    force_update               = optional(bool)
    recreate_pods              = optional(bool)
    max_history                = optional(number)
    wait                       = optional(bool)
    create_namespace           = optional(bool)
    namespace                  = optional(string)
    cleanup_on_fail            = optional(bool)
    disable_crd_hooks          = optional(bool)
    disable_openapi_validation = optional(bool)
    disable_webhooks           = optional(bool)
    skip_crds                  = optional(bool)
    atomic                     = optional(bool)
    dependency_update          = optional(bool)
    pass_credentials           = optional(bool)
    wait_for_jobs              = optional(bool)
    values                     = optional(list(string))
    set = optional(list(object({
      name  = string
      value = string
    })))
  }))
  default = {}
}
