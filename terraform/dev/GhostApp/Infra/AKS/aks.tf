data "azuread_groups" "akscluster01-admins" {
  display_names    = ["Global-Administrators"]
  security_enabled = true
}

module "akscluster01" {
  #checkov:skip=CKV_AZURE_170:Ensure that AKS use the Paid Sku for its SLA. Not applicable
  source                                = "../../../../modules/terraform-azure-aks"

  resource_group_name                   = module.resource-group-01.name
  nodes_resource_group_name             = "${var.environment-prefix}AKSCluster01-Resources"
  cluster_name                          = "${var.environment-prefix}AKSCluster01"
  location                              = var.location
  dns_prefix                            = "local"
  default_nodepool_subnet_id            = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[7]
  rbac_aad_admin_group_object_ids       = data.azuread_groups.akscluster01-admins.object_ids
  log_analytics_workspace_id            = module.log01.log_analytics_workspace_id
  enable_log_analytics_workspace        = true
  kubernetes_version                    = "1.30.3"
  sku_tier                              = "Free"
  private_cluster_enabled               = false
  enable_azure_policy                   = true
  ingress_application_gateway_enabled   = false
  microsoft_defender_enabled            = true
  key_vault_secrets_provider_enabled    = true
  msi_auth_for_monitoring_enabled       = true
  oidc_issuer_enabled                   = true
  workload_identity_enabled             = true
  #ingress_application_gateway_name      = "${var.environment-prefix}AppGateway"
  #ingress_application_gateway_subnet_id = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[5]

  default_nodepool_vm_size              = "Standard_B4ms"
  net_policy                            = "azure"
  net_data_plane                        = "azure"

  aks_additional_node_pools = {
    apppool01 = {
      node_count                     = 1
      mode                           = "System" #"User" Set it to system in order to no pay for the running node due Basic tier
      name                           = "apppool01"
      vm_size                        = "Standard_B4ms"
      zones                          = ["1"]
      taints                         = null
      labels = {
        nodepool : "apppool01"
      }
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      cluster_subnet_id              = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[7]
    }
  }

  monitor_metrics = {
    annotations_allowed = "environment, owner, team, app-version"
    labels_allowed      = "app, tier, release, environment"
  }

  depends_on = [
    module.log01
  ]
}

module "akscluster01-alb-identity" {
  source = "../../../../modules/terraform-azure-identity"
  uai_name                    = "${var.environment-prefix}ALB-UserIdentity"
  resource_group_name         = module.resource-group-01.name
  location                    = var.location  
  enable_identity_credential  = true
  federated_identity_audience = ["api://AzureADTokenExchange"]
  federated_identity_issuer   = module.akscluster01.oidc_issuer_url
  federated_identity_subject  = "system:serviceaccount:azure-alb-system:alb-controller-sa"
}

module "akscluster01-diag" {
  source      = "../../../../modules/terraform-azure-diagnostic-settings"

  log_categories                 = ["kube-apiserver", "kube-audit-admin", "kube-scheduler", "cluster-autoscaler"]
  metric_categories              = [null]
  log_analytics_destination_type = "Dedicated"
  resource_id                    = module.akscluster01.aks_id

  logs_destinations_ids = [
    module.log01.log_analytics_workspace_id
  ]
}

module "akscluster01-apps" {
  source         = "../../../../modules/terraform-azure-aks-helm"
  kubeconfig     = data.azurerm_kubernetes_cluster.akscluster01.kube_config_raw

  release = {
    alb-controller = {
      repository_name     = "application-lb"
      namespace           = "azure-alb-system"
      chart               = "alb-controller"
      repository          = "oci://mcr.microsoft.com/application-lb/charts"
      repository_username = null
      repository_password = null
      version             = "1.0.7"
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
      set                 = [
        {
          name  = "albController.podIdentity.clientID"
          value = module.akscluster01-alb-identity.uai_client_id
        }     
      ]      
    },

    alb-resource = {
      repository_name     = "raw"
      namespace           = null
      chart               = "raw"
      repository          = "https://dysnix.github.io/charts"
      repository_username = null
      repository_password = null
      version             = "v0.3.1"
      verify              = false
      reuse_values        = false
      reset_values        = false
      force_update        = true
      timeout             = 3600
      recreate_pods       = false
      max_history         = 200
      wait                = true
      create_namespace    = true
      set                 = null
      values = [
        <<-EOF
        resources:
          - apiVersion: v1
            kind: Namespace
            metadata:
              name: ns-gateway
          - apiVersion: gateway.networking.k8s.io/v1beta1
            kind: Gateway
            metadata:
              name: gateway-app
              namespace: ns-gateway
              annotations:
                alb.networking.azure.io/alb-id: ${module.akscluster01-app-gateway-containers.id}
            spec:
              gatewayClassName: azure-alb-external
              listeners:
              - name: http-listener
                port: 80
                protocol: HTTP
                allowedRoutes:
                  namespaces:
                    from: All # Same
              addresses:
              - type: alb.networking.azure.io/alb-frontend
                value: ${module.akscluster01-app-gateway-containers.frontend_name}
        EOF
      ]
    }
    nginx-demo = {
      repository_name     = "demo-application"
      namespace           = "demo-app"
      chart               = "frontend"
      repository          = "https://mohdazhar96.github.io/Frontend-app-Helmchart/frontend/chart"
      repository_username = null
      repository_password = null
      version             = "0.1.0"
      verify              = false
      reuse_values        = false
      reset_values        = false
      force_update        = true
      timeout             = 3600
      recreate_pods       = false
      max_history         = 200
      wait                = false
      create_namespace    = true
      set = [
        {
          name  = "service.port"
          value = "80"
        },
        {
          name = "service.type"
          value = "ClusterIP"
        }
      ]
    },
    demoapp-route = {
      repository_name     = "raw"
      namespace           = "demo-app"
      chart               = "raw"
      repository          = "https://dysnix.github.io/charts"
      repository_username = null
      repository_password = null
      version             = "v0.3.1"
      verify              = false
      reuse_values        = false
      reset_values        = false
      force_update        = true
      timeout             = 3600
      recreate_pods       = false
      max_history         = 200
      wait                = true
      create_namespace    = false
      set                 = null
      values = [
        <<-EOF
        resources:
          - apiVersion: gateway.networking.k8s.io/v1beta1
            kind: HTTPRoute
            metadata:
              name: httproute-app
              namespace: demo-app
            spec:
              parentRefs:
              - kind: Gateway
                name: gateway-app
                namespace: ns-gateway
              rules:
              - backendRefs:
                - name: nginx-demo-frontend
                  port: 80
        EOF 
      ]
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

//https://faultbucket.ca/2023/06/azure-managed-prometheus-and-grafana-with-terraform-part-2/

module "azpi_noderecordingrulesrulegroup_aks01" {
  source    = "../../../../modules/terraform-azure-azapi-resource"

  name                      = "NodeRecordingRulesRuleGroup-${module.akscluster01.name}"
  type                      = "Microsoft.AlertsManagement/prometheusRuleGroups@2023-03-01"
  location                  = var.location
  parent_id                 = module.resource-group-01.id
  schema_validation_enabled = false
  ignore_missing_property   = false   
  body                      = jsonencode({
    "properties" : {
      "scopes" : [
        module.monitor-workspace01.id
      ],
      "clusterName" : module.akscluster01.name,
      "interval" : "PT1M",
      "rules" : [
        {
          "record" : "instance:node_num_cpu:sum",
          "expression" : "count without (cpu, mode) (  node_cpu_seconds_total{job=\"node\",mode=\"idle\"})"
        },
        {
          "record" : "instance:node_cpu_utilisation:rate5m",
          "expression" : "1 - avg without (cpu) (  sum without (mode) (rate(node_cpu_seconds_total{job=\"node\", mode=~\"idle|iowait|steal\"}[5m])))"
        },
        {
          "record" : "instance:node_load1_per_cpu:ratio",
          "expression" : "(  node_load1{job=\"node\"}/  instance:node_num_cpu:sum{job=\"node\"})"
        },
        {
          "record" : "instance:node_memory_utilisation:ratio",
          "expression" : "1 - (  (    node_memory_MemAvailable_bytes{job=\"node\"}    or    (      node_memory_Buffers_bytes{job=\"node\"}      +      node_memory_Cached_bytes{job=\"node\"}      +      node_memory_MemFree_bytes{job=\"node\"}      +      node_memory_Slab_bytes{job=\"node\"}    )  )/  node_memory_MemTotal_bytes{job=\"node\"})"
        },
        {
          "record" : "instance:node_vmstat_pgmajfault:rate5m",
          "expression" : "rate(node_vmstat_pgmajfault{job=\"node\"}[5m])"
        },
        {
          "record" : "instance_device:node_disk_io_time_seconds:rate5m",
          "expression" : "rate(node_disk_io_time_seconds_total{job=\"node\", device!=\"\"}[5m])"
        },
        {
          "record" : "instance_device:node_disk_io_time_weighted_seconds:rate5m",
          "expression" : "rate(node_disk_io_time_weighted_seconds_total{job=\"node\", device!=\"\"}[5m])"
        },
        {
          "record" : "instance:node_network_receive_bytes_excluding_lo:rate5m",
          "expression" : "sum without (device) (  rate(node_network_receive_bytes_total{job=\"node\", device!=\"lo\"}[5m]))"
        },
        {
          "record" : "instance:node_network_transmit_bytes_excluding_lo:rate5m",
          "expression" : "sum without (device) (  rate(node_network_transmit_bytes_total{job=\"node\", device!=\"lo\"}[5m]))"
        },
        {
          "record" : "instance:node_network_receive_drop_excluding_lo:rate5m",
          "expression" : "sum without (device) (  rate(node_network_receive_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
        },
        {
          "record" : "instance:node_network_transmit_drop_excluding_lo:rate5m",
          "expression" : "sum without (device) (  rate(node_network_transmit_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
        }
      ]
    }
  })   
}

module "azpi_kubernetesreccordingrulesrulegroup_aks01" {
  source    = "../../../../modules/terraform-azure-azapi-resource"

  name                      = "KubernetesReccordingRulesRuleGroup-${module.akscluster01.name}"
  type                      = "Microsoft.AlertsManagement/prometheusRuleGroups@2023-03-01"
  location                  = var.location
  parent_id                 = module.resource-group-01.id
  schema_validation_enabled = false
  ignore_missing_property   = false
  body = jsonencode({
    "properties" : {
      "scopes" : [
        module.monitor-workspace01.id
      ],
      "clusterName" : module.akscluster01.name,
      "interval" : "PT1M",
      "rules" : [
        {
          "record" : "node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate",
          "expression" : "sum by (cluster, namespace, pod, container) (  irate(container_cpu_usage_seconds_total{job=\"cadvisor\", image!=\"\"}[5m])) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (  1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=\"\"}))"
        },
        {
          "record" : "node_namespace_pod_container:container_memory_working_set_bytes",
          "expression" : "container_memory_working_set_bytes{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
        },
        {
          "record" : "node_namespace_pod_container:container_memory_rss",
          "expression" : "container_memory_rss{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
        },
        {
          "record" : "node_namespace_pod_container:container_memory_cache",
          "expression" : "container_memory_cache{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
        },
        {
          "record" : "node_namespace_pod_container:container_memory_swap",
          "expression" : "container_memory_swap{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
        },
        {
          "record" : "cluster:namespace:pod_memory:active:kube_pod_container_resource_requests",
          "expression" : "kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1))"
        },
        {
          "record" : "namespace_memory:kube_pod_container_resource_requests:sum",
          "expression" : "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
        },
        {
          "record" : "cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests",
          "expression" : "kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1))"
        },
        {
          "record" : "namespace_cpu:kube_pod_container_resource_requests:sum",
          "expression" : "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
        },
        {
          "record" : "cluster:namespace:pod_memory:active:kube_pod_container_resource_limits",
          "expression" : "kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1))"
        },
        {
          "record" : "namespace_memory:kube_pod_container_resource_limits:sum",
          "expression" : "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
        },
        {
          "record" : "cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits",
          "expression" : "kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ( (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1) )"
        },
        {
          "record" : "namespace_cpu:kube_pod_container_resource_limits:sum",
          "expression" : "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
        },
        {
          "record" : "namespace_workload_pod:kube_pod_owner:relabel",
          "expression" : "max by (cluster, namespace, workload, pod) (  label_replace(    label_replace(      kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"ReplicaSet\"},      \"replicaset\", \"$1\", \"owner_name\", \"(.*)\"    ) * on(replicaset, namespace) group_left(owner_name) topk by(replicaset, namespace) (      1, max by (replicaset, namespace, owner_name) (        kube_replicaset_owner{job=\"kube-state-metrics\"}      )    ),    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))",
          "labels" : {
            "workload_type" : "deployment"
          }
        },
        {
          "record" : "namespace_workload_pod:kube_pod_owner:relabel",
          "expression" : "max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"DaemonSet\"},    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))",
          "labels" : {
            "workload_type" : "daemonset"
          }
        },
        {
          "record" : "namespace_workload_pod:kube_pod_owner:relabel",
          "expression" : "max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"StatefulSet\"},    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))",
          "labels" : {
            "workload_type" : "statefulset"
          }
        },
        {
          "record" : "namespace_workload_pod:kube_pod_owner:relabel",
          "expression" : "max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"Job\"},    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))",
          "labels" : {
            "workload_type" : "job"
          }
        },
        {
          "record" : ":node_memory_MemAvailable_bytes:sum",
          "expression" : "sum(  node_memory_MemAvailable_bytes{job=\"node\"} or  (    node_memory_Buffers_bytes{job=\"node\"} +    node_memory_Cached_bytes{job=\"node\"} +    node_memory_MemFree_bytes{job=\"node\"} +    node_memory_Slab_bytes{job=\"node\"}  )) by (cluster)"
        },
        {
          "record" : "cluster:node_cpu:ratio_rate5m",
          "expression" : "sum(rate(node_cpu_seconds_total{job=\"node\",mode!=\"idle\",mode!=\"iowait\",mode!=\"steal\"}[5m])) by (cluster) /count(sum(node_cpu_seconds_total{job=\"node\"}) by (cluster, instance, cpu)) by (cluster)"
        }
      ]
    }
  })
}

