
module "public-dns" {
  source  = "../../../modules/terraform-azure-public-dns"

  name    = "fabriziozavalloni.com.br"
  rg_name = module.resource-group-01.name

  a_records     = [
    {
      name = "blog"
      ips  = [
        "20.13.86.32"
      ]
    },
    {
      name = "ghost"
      ips  = [
        "20.13.86.32"
      ]
    }
  ]

  depends_on = [
    module.resource-group-01
  ]
}
