output "shared_vnet01" {
  value = module.vnet01.vnet_id
}
output "shared_subnets_vnet01" {
  value = module.vnet01.vnet_subnets
}