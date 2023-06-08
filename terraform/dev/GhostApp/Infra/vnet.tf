module "vnet01" {
  source              = "../../../modules/terraform-azure-vnet"
  resource_group_name = module.resource-group-01.name
  virtualnet_name     = "${var.environment-prefix}VNET01"
  address_space       = ["10.15.0.0/16"]
  location            = var.location

  subnet_names = [
    {
      name                                           = "ApiMgmtSubnet"
      address_prefixes                               = ["10.15.254.232/29"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    },
    {
      name                                           = "GatewaySubnet"
      address_prefixes                               = ["10.15.254.240/28"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    },
    {
      name                                           = "AzureBastionSubnet"
      address_prefixes                               = ["10.15.254.192/27"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    },
    {
      name                                           = "${var.environment-prefix}SUBNET-10.115.0.0_24"
      address_prefixes                               = ["10.15.0.0/24"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    },
    {
      name                                           = "${var.environment-prefix}SUBNET-10.115.1.0_24"
      address_prefixes                               = ["10.15.1.0/24"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    },
    {
      name                                           = "${var.environment-prefix}SUBNET-10.115.2.0_24"
      address_prefixes                               = ["10.15.2.0/24"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    },
    {
      name                                           = "${var.environment-prefix}SUBNET-10.115.3.0_24"
      address_prefixes                               = ["10.15.3.0/24"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {
                                                          fs = [
                                                            {
                                                              name    = "Microsoft.DBforMySQL/flexibleServers"
                                                              actions = [                                                                                                                                
                                                                "Microsoft.Network/virtualNetworks/subnets/join/action"
                                                              ]
                                                            }
                                                          ]
                                                        }
    },
    {
      name                                           = "${var.environment-prefix}SUBNET-10.115.16.0_20"
      address_prefixes                               = ["10.15.16.0/20"]
      enforce_private_link_endpoint_network_policies = false
      service_endpoints                              = []
      delegation                                     = {}
    }
  ]

  depends_on = [ 
    module.resource-group-01 
  ]
}
