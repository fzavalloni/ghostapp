terraform {
  required_providers {
    azurerm = ">= 2.95.0"
  }
}

resource "azurerm_dns_zone" "main" {
  name                = var.name
  resource_group_name = var.rg_name
  tags                = var.tags
  dynamic "soa_record" {
    for_each = var.soa_records
    content {
      email         = soa_record.value.email
      host_name     = soa_record.value.host_name
      expire_time   = lookup(expire_time.value, "expire_time", null)
      minimum_ttl   = lookup(minimum_ttl.value, "minimum_ttl", null)
      refresh_time  = lookup(refresh_time.value, "refresh_time", null)
      retry_time    = lookup(retry_time.value, "retry_time", null)
      serial_number = lookup(serial_number.value, "serial_number", null)
      ttl           = lookup(ttl.value, "ttl", null)
    }
  }  
}

resource "azurerm_dns_a_record" "this" {
  count               = length(var.a_records)
  name                = lookup(var.a_records[count.index], "name")
  zone_name           = var.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = lookup(var.a_records[count.index], "ips")
}