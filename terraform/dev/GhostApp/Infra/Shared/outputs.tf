output "shared_vnet01" {
  value = module.vnet01.vnet_id
}
output "shared_subnets_vnet01" {
  value = module.vnet01.vnet_subnets
}
output "shared_storage01_id" {
  value = module.storage_shared_01.storage_account_id
}
output "shared_storage01_name" {
  value = module.storage_shared_01.storage_account_name
}
output "shared_storage01_containers" {
  value = module.storage_shared_01.storage_containers
}
output "shared_resource_group_id" {
  value = module.shared-resource-group.id
}
output "shared_resource_group_name" {
  value = module.shared-resource-group.name
}