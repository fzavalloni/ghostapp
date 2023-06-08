
module "akscluster01-apps" {
  source         = "../../../modules/terraform-azure-aks-helm"
  kubeconfig     = data.azurerm_kubernetes_cluster.akscluster01.kube_config_raw

  release = {
    # Set up cert-manager + letsencrypt 
    cert-manager = {
      repository_name     = "cert-manager"
      namespace           = "cert-manager"
      chart               = "cert-manager"
      repository          = "https://charts.jetstack.io"
      repository_username = null
      repository_password = null
      version             = "v1.10.2"
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
          name  = "installCRDs"
          value = "true"
        }     
      ]      
    }

    letsencrypt = {
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
          - apiVersion: cert-manager.io/v1
            kind: ClusterIssuer
            metadata:
              name: letsencrypt-prod              
            spec:
              acme:
                email: fzavalloni@hotmail.com
                server: https://acme-v02.api.letsencrypt.org/directory
                privateKeySecretRef:
                  name: letsencrypt-prod
                solvers:
                - http01:
                    ingress:
                      class: azure/application-gateway
        EOF
      ]      
    }
   
   # Install Ghost App from https://github.com/bitnami/charts/tree/main/bitnami/ghost/
   # The application does not support multi instances, that's the reason I couldn't enable the horizontal pod scale
   # https://ghost.org/docs/faq/clustering-sharding-multi-server/
    ghost-app = {
      repository_name     = "bitnami"
      namespace           = "ghost"
      chart               = "ghost"
      repository          = "https://charts.bitnami.com/bitnami"
      repository_username = null
      repository_password = null
      version             = "19.3.5"
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
          name  = "allowEmptyPassword"
          value = "false"
        },
        {
          name  = "service.type"
          value = "ClusterIP"
        },
        {
          name  = "ghostEmail"
          value = "fzavalloni@hotmail.com"
        },        
        {
          name  = "ghostPassword"
          value = "${var.ghost_app_password}"
        },
        {
          name  = "externalDatabase.host"
          value = "${data.azurerm_mysql_flexible_server.mysql-db.fqdn}" 
        },
        {
          name  = "externalDatabase.user"
          value = "${data.azurerm_mysql_flexible_server.mysql-db.administrator_login}"
        },
        {
          name  = "externalDatabase.password"
          value = "${var.ghost_app_password}"
        },
        {
          name  = "externalDatabase.database"
          value = "ghost_db"
        },
        {
          name  = "mysql.enabled"
          value = "false"
        },      
        {
          name  = "externalDatabase.port"
          value = "3306"
        },
        {
          name  = "replicaCount"
          value = "1"
        },
        {
          name  = "nodeSelector.nodepool"   # comment out if you don't want to pin your application to an specific node pool
          value = "apppool01"
        },
        
        # {
        #   name  = "resources.limits.cpu"
        #   value = "1000m"
        # },
        # {
        #   name  = "resources.requests.cpu"
        #   value = "750m"
        # },
      ]
    }

    # Creates the App Gateway ingress
    ingress-ghost = {
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
      create_namespace    = false
      set                 = null
      values = [
        <<-EOF
        resources:
          - apiVersion: networking.k8s.io/v1
            kind: Ingress        
            metadata:
              name: app-ghost-ingress
              namespace: ghost
              annotations:
                cert-manager.io/cluster-issuer: letsencrypt-prod
                certmanager.k8s.io/cluster-issuer: letsencrypt-prod 
                appgw.ingress.kubernetes.io/ssl-redirect: 'true'         
                appgw.ingress.kubernetes.io/backend-path-prefix: /
                kubernetes.io/ingress.class: azure/application-gateway              
            spec:
              tls:
                - hosts:
                    - blog.fabriziozavalloni.com.br
                  secretName: keyvault-ingress-ghost
              rules:
                - host: blog.fabriziozavalloni.com.br
                  http:
                    paths:
                      - path: /
                        pathType: Prefix
                        backend:
                          service:
                            name: ghost-app
                            port:
                              name: http
        EOF
      ]      
    }

    # Application does not support mutiple nodes even with a external database
    # The application crashed continuously

    # ghostapp-hpa = {
    #   repository_name     = "raw"
    #   namespace           = null
    #   chart               = "raw"
    #   repository          = "https://dysnix.github.io/charts"
    #   repository_username = null
    #   repository_password = null
    #   version             = "v0.3.1"
    #   verify              = false
    #   reuse_values        = false
    #   reset_values        = false
    #   force_update        = true
    #   timeout             = 3600
    #   recreate_pods       = false
    #   max_history         = 200
    #   wait                = true
    #   create_namespace    = false
    #   set                 = null
    #   values = [
    #     <<-EOF
    #     resources:
    #       - apiVersion: autoscaling/v1
    #         kind: HorizontalPodAutoscaler
    #         metadata:
    #           name: ghost-hpa
    #           namespace: ghost
    #         spec:
    #           maxReplicas: 2 # define max replica count
    #           minReplicas: 1  # define min replica count
    #           scaleTargetRef:
    #             apiVersion: apps/v1
    #             kind: Deployment
    #             name: ghost-app
    #           targetCPUUtilizationPercentage: 30 # target CPU utilization
    #     EOF
    #   ]      
    # }
  }
}
