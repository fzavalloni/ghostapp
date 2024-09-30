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
              name: ${var.application_gateway_containers_namespace}
          - apiVersion: gateway.networking.k8s.io/v1beta1
            kind: Gateway
            metadata:
              name: ${var.application_gateway_containers_name}
              namespace: ${var.application_gateway_containers_namespace}
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
                name: ${var.application_gateway_containers_name}
                namespace: ${var.application_gateway_containers_namespace}
              rules:
              - backendRefs:
                - name: nginx-demo-frontend
                  port: 80
        EOF 
      ]
    }
  }
}