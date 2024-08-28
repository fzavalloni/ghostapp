#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Main
*/
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Sets Providers and Versions
*/
#------------------------------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0"
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Module Logic
  - Resource block to create Azure DNS Zone.
    - Dynamic block to create SOA Record(s).
  - Resource block to create Azure DNS Zone A Record(s).
  - Resource block to create Azure DNS Zone AAAA Record(s).
  - Resource block to create Azure DNS Zone CAA Record(s).
  - Resource block to create Azure DNS Zone CNAME Record(s).
  - Resource block to create Azure DNS Zone MX Record(s).
  - Resource block to create Azure DNS Zone NS Record(s).
  - Resource block to create Azure DNS Zone PTR Record(s).
  - Resource block to create Azure DNS Zone SRV Record(s).
  - Resource block to create Azure DNS Zone TXT Record(s).
*/
#------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_zone" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
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
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone A Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_a_record" "this" {
  for_each = var.dns_a_records

  name                = each.value.name
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  records            = each.value.records != null && each.value.records != "" ? each.value.records : null
  target_resource_id = each.value.target_resource_id != null && each.value.target_resource_id != "" ? each.value.target_resource_id : null
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone AAAA Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_aaaa_record" "this" {
  for_each = var.dns_aaaa_records

  name                = each.value.name
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  records            = each.value.records != null && each.value.records != "" ? each.value.records : null
  target_resource_id = each.value.target_resource_id != null && each.value.target_resource_id != "" ? each.value.target_resource_id : null
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone CAA Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_caa_record" "this" {
  for_each = var.dns_caa_records

  name                = each.value.name
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  tags                = each.value.tags

  dynamic "record" {
    for_each = each.value.records
    content {
      flags = record.value.flags
      tag   = record.value.tag
      value = record.value.value
    }
  }
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone CNAME Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_cname_record" "this" {
  for_each = var.dns_cname_records

  name                = each.value.name
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  record              = each.value.record
  tags                = each.value.tags
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone MX Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_mx_record" "this" {
  for_each = { for mx in var.dns_mx_records : mx.name => mx }

  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }

  tags = each.value.tags
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone NS Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_ns_record" "this" {
  for_each = { for ns in var.dns_ns_records : ns.name => ns }

  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = each.value.tags
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone PTR Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_ptr_record" "this" {
  for_each = { for ptr in var.dns_ptr_records : ptr.name => ptr }

  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = each.value.tags
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone SRV Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_srv_record" "this" {
  for_each = { for srv in var.dns_srv_records : srv.name => srv }

  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }

  tags = each.value.tags
}
#------------------------------------------------------------------------------------------------------------------------------------------
/*
  Create Azure DNS Zone TXT Record(s)
*/
#------------------------------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_txt_record" "this" {
  for_each = { for txt in var.dns_txt_records : txt.name => txt }

  name                = each.key
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records
    content {
      value = record.value
    }
  }

  tags = each.value.tags
}
