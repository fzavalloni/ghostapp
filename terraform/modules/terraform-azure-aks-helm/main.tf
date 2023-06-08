terraform {
  required_providers {
    azurerm = ">= 2.95.0"
  }
}

# This module should not be used to deploy helm charts
# It has been used only for test purposes, 
# we use a different approach

resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}

resource "helm_release" "this" {
  for_each = var.release

  name                = substr(each.key, 0, 30)
  chart               = each.value.chart
  repository          = each.value.repository
  repository_username = each.value.repository_name
  repository_password = each.value.repository_password
  version             = each.value.version
  verify              = each.value.verify
  timeout             = each.value.timeout
  reuse_values        = each.value.reuse_values
  reset_values        = each.value.reset_values
  force_update        = each.value.force_update
  recreate_pods       = each.value.recreate_pods
  max_history         = each.value.max_history
  wait                = each.value.wait
  values              = each.value.values
  namespace           = each.value.namespace
  create_namespace    = each.value.create_namespace

  dynamic "set" {
    iterator = item
    for_each = each.value.set == null ? [] : each.value.set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}