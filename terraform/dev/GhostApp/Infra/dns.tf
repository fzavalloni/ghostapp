
module "public-dns" {
  source              = "../../../modules/terraform-azure-public-dns"

  name                = "fabriziozavalloni.com.br"
  resource_group_name = module.resource-group-01.name

  dns_a_records       = {
    record1 = {
      name     = "blog"
      ttl      = 300
      records  = [
        "20.13.86.32"
      ]
    },
    record2 = {
      name     = "ghost"
      ttl      = 300
      records  = [
        "20.13.86.32"
      ]
    }
  }

  depends_on = [
    module.resource-group-01
  ]
}
