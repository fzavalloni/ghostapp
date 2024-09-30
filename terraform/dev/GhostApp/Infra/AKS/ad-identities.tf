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