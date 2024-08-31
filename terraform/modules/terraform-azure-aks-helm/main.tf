terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
  }
}
resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}
resource "helm_release" "this" {
  for_each                   = var.release
  name                       = substr(each.key, 0, 30)
  chart                      = each.value.chart
  description                = each.value.description
  render_subchart_notes      = each.value.render_subchart_notes
  repository                 = each.value.repository
  repository_username        = each.value.repository_username
  repository_password        = each.value.repository_password
  version                    = each.value.version
  verify                     = each.value.verify
  timeout                    = each.value.timeout
  reuse_values               = each.value.reuse_values
  reset_values               = each.value.reset_values
  force_update               = each.value.force_update
  recreate_pods              = each.value.recreate_pods
  max_history                = each.value.max_history
  wait                       = each.value.wait
  create_namespace           = each.value.create_namespace
  namespace                  = each.value.namespace
  cleanup_on_fail            = each.value.cleanup_on_fail
  disable_crd_hooks          = each.value.disable_crd_hooks
  disable_openapi_validation = each.value.disable_openapi_validation
  disable_webhooks           = each.value.disable_webhooks
  skip_crds                  = each.value.skip_crds
  atomic                     = each.value.atomic
  dependency_update          = each.value.dependency_update
  pass_credentials           = each.value.pass_credentials
  wait_for_jobs              = each.value.wait_for_jobs
  values                     = each.value.values

  dynamic "set" {
    iterator = item
    for_each = each.value.set == null ? [] : each.value.set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}
