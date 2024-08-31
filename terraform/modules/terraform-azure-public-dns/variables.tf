variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure DNS Zone."
  type        = string
  nullable    = false
}
variable "name" {
  description = "(Required) The name for this Azure DNS Zone."
  type        = string
  nullable    = false
}
variable "soa_records" {
  description = "(Optional) List of SOA DNS entries for use on this Azure DNS Zone. Defaults to `[]`."
  type        = any
  default     = []
}
variable "dns_a_records" {
  description = <<EOT
  (Optional) A map of DNS A records configurations for creation in this Azure DNS Zone. Defaults to `{}`.

  Example Inputs(s)
  ```hcl
  dns_a_records = {
    record1 = {
      name                = "test1"
      ttl                 = 300
      records             = ["10.0.180.17"]
      target_resource_id  = ""
    },
    record2 = {
      name                = "test2"
      ttl                 = 300
      records             = []
      target_resource_id  = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/publicIPAddresses/mypublicip"
    }
  }
  ```hcl
  EOT
  type = map(object({
    name               = string
    ttl                = number
    records            = optional(list(string))
    target_resource_id = optional(string)
  }))
  default = {}
}
variable "dns_aaaa_records" {
  description = <<EOT
  (Optional) A map of DNS AAAA records configurations for creation in this Azure DNS Zone. Defaults to `{}`.

  Example Input(s)
  ```hcl
  dns_aaaa_records = {
    record1 = {
      name                = "test1"
      ttl                 = 300
      records             = ["2001:db8::1"]
      target_resource_id  = ""
    },
    record2 = {
      name                = "test2"
      ttl                 = 300
      records             = []
      target_resource_id  = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/publicIPAddresses/mypublicip"
    }
  }
  ```
  EOT
  type = map(object({
    name               = string
    ttl                = number
    records            = optional(list(string))
    target_resource_id = optional(string)
  }))
  default = {}
}
variable "dns_caa_records" {
  description = <<EOT
  (Optional) A map of DNS CAA records configurations for creation in this Azure DNS Zone. Defaults to `{}`.

  Example Input(s)
  ```hcl
  dns_caa_records = {
    record1 = {
      name                = "test1"
      ttl                 = 300
      records             = [
        {
          flags = 0
          tag   = "issue"
          value = "example.com"
        },
        {
          flags = 0
          tag   = "issue"
          value = "example.net"
        }
      ]
      tags = {
        Environment = "Production"
      }
    },
    record2 = {
      name                = "test2"
      ttl                 = 300
      records             = [
        {
          flags = 0
          tag   = "issuewild"
          value = ";"
        },
        {
          flags = 0
          tag   = "iodef"
          value = "mailto:terraform@nonexisting.tld"
        }
      ]
      tags = {
        Environment = "Staging"
      }
    }
  }
  ```
  EOT
  type = map(object({
    name = string
    ttl  = number
    records = list(object({
      flags = number
      tag   = string
      value = string
    }))
    tags = map(string)
  }))
  default = {}
}
variable "dns_cname_records" {
  description = <<EOT
  (Optional) A map of DNS CNAME records configurations for creation in this Azure DNS Zone. Defaults to `{}`.

  Example Input(s)
  ```hcl
  dns_cname_records = {
    record1 = {
      name                = "test1"
      ttl                 = 300
      record              = "contoso.com"
      tags = {
        Environment = "Production"
      }
    },
    record2 = {
      name                = "test2"
      ttl                 = 300
      record              = "example.com"
      tags = {
        Environment = "Staging"
      }
    }
  }
```
EOT
  type = map(object({
    name   = string
    ttl    = number
    record = string
    tags   = map(string)
  }))
  default = {}
}
variable "dns_mx_records" {
  description = <<EOT
  (Optional) A list of DNS MX records configurations for creation in this Azure DNS Zone. Defaults to `[]`.

  Example Input(s)
  ```hcl
  dns_mx_records = [
    {
      name = "test1"
      ttl  = 300
      records = [
        {
          preference = 10
          exchange   = "mail1.contoso.com"
        },
        {
          preference = 20
          exchange   = "mail2.contoso.com"
        }
      ]
      tags = {
        Environment = "Production"
      }
    },
    {
      name = "test2"
      ttl  = 300
      records = [
        {
          preference = 10
          exchange   = "mail1.example.com"
        },
        {
          preference = 20
          exchange   = "mail2.example.com"
        }
      ]
      tags = {
        Environment = "Staging"
      }
    }
  ]
  ```
  EOT
  type = list(object({
    name = string
    ttl  = number
    records = list(object({
      preference = number
      exchange   = string
    }))
    tags = map(string)
  }))
  default = []
}
variable "dns_ns_records" {
  description = <<EOT
  (Optional) A list of DNS NS records configurations for creation in this Azure DNS Zone. Defaults to `[]`.

  Example Input(s)
  ```hcl
  dns_ns_records = [
    {
      name = "test1"
      ttl  = 300
      records = [
        "ns1.contoso.com.",
        "ns2.contoso.com."
      ]
      tags = {
        Environment = "Production"
      }
    },
    {
      name = "test2"
      ttl  = 300
      records = [
        "ns1.example.com.",
        "ns2.example.com."
      ]
      tags = {
        Environment = "Staging"
      }
    }
  ]
  ```
  EOT
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
    tags    = map(string)
  }))
  default = []
}
variable "dns_ptr_records" {
  description = <<EOT
  (Optional) A list of DNS PTR records configurations for creation in this Azure DNS Zone. Defaults to `[]`

  Example Input(s)
  ```hcl
  dns_ptr_records = [
    {
      name = "ptr1"
      ttl  = 300
      records = [
        "yourdomain1.com"
      ]
      tags = {
        Environment = "Production"
      }
    },
    {
      name = "ptr2"
      ttl  = 300
      records = [
        "yourdomain2.com"
      ]
      tags = {
        Environment = "Staging"
      }
    }
  ]
  ```
  EOT
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
    tags    = map(string)
  }))
  default = []
}
variable "dns_srv_records" {
  description = <<EOT
  (Optional) A list of DNS SRV records configurations for creation in this Azure DNS Zone. Defaults to `[]`

  Example Input(s)
  ```hcl
  dns_srv_records = [
    {
      name = "srv1"
      ttl  = 300
      records = [
        {
          priority = 1
          weight   = 5
          port     = 8080
          target   = "target1.contoso.com"
        },
        {
          priority = 2
          weight   = 10
          port     = 8081
          target   = "target2.contoso.com"
        }
      ]
      tags = {
        Environment = "Production"
      }
    }
  ]
  ```
  EOT
  type = list(object({
    name = string
    ttl  = number
    records = list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
    tags = map(string)
  }))
  default = []
}
variable "dns_txt_records" {
  description = <<EOT
  (Optional) A list of DNS TXT records configurations for creation in this Azure DNS Zone. Defaults to `[]`.

  Example Input(s)
  ```hcl
  dns_txt_records = [
    {
      name = "txt1"
      ttl  = 300
      records = [
        "google-site-authenticator",
        "more site information here"
      ]
      tags = {
        Environment = "Production"
      }
    }
  ]
  ```
  EOT
  type = list(object({
    name    = string
    ttl     = number
    records = list(string)
    tags    = map(string)
  }))
  default = []
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
