variable "instance_name" {
  description = "The name of this managed Grafana instance."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}
variable "location" {
  description = "The location to create the resources in."
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
variable "grafana_major_version" {
  description = "The major version of Grafana to use."
  type        = string
  default     = "9"
}
variable "grafana_admin_object_id" {
  description = "The object ID of the user to assign the Grafana Admin role to."
  type        = string
}
variable "subscription_id" {
  description = "The ID of the subscription to create the resources in."
  type        = string
}
variable "public_network_access_enabled" {
  description = "Whether or not public network access is enabled for the Grafana instance."
  type        = bool
  default     = true
}
variable "api_key_enabled" {
  description = "Whether or not API key authentication is enabled for the Grafana instance."
  type        = bool
  default     = false
}
variable "grafana_auth_token" {
  description = "The authentication token for the Grafana instance."
  type        = string
  default     = ""
}
variable "monitor_workspace" {
  description = "The Azure Monitor Workspace to integrate with Grafana."
  type = object({
    name                                = string
    id                                  = string
    query_endpoint                      = string
    default_data_collection_endpoint_id = string
    default_data_collection_rule_id     = string
  })
}