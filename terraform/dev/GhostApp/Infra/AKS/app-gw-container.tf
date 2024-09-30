module "akscluster01-app-gateway-containers" {
  source              = "../../../../modules/terraform-azure-app-load-balancer"

  name                = "${var.environment-prefix}AppGatewayContainers01"
  frontend_name       = "${var.environment-prefix}FrontEnd01"
  resource_group_name = module.resource-group-01.name
  location            = var.location

  subnet_associations = {
    VNET01 = {
      name      =  "GatewayVNET01"
      subnet_id = data.terraform_remote_state.shared.outputs.shared_subnets_vnet01[5]
    }   
  }
}