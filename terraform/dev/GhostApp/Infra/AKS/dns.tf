
module "public-dns" {
  source              = "../../../../modules/terraform-azure-public-dns"

  name                = "fabriziozavalloni.com.br"
  resource_group_name = module.resource-group-01.name

  dns_cname_records   = {
    record1 = {
      name   = "www"
      ttl    = 300
      record = module.akscluster01-app-gateway-containers.frontend_fqdn
      tags   = {}
    }
  }
}
