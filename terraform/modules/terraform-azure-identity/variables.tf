variable "resource_group_name" {
  description = "(Required) Name of the resource group to be used when creating this Azure Entra User Assigned Identity."
  type        = string
  nullable    = false
}
variable "location" {
  description = "(Required) Location to be used when creating this Azure Entra User Assigned Identity."
  type        = string
  nullable    = false
}
variable "uai_name" {
  description = "(Required) Specifies the name of this Azure Entra User Assigned Identity. Changing this forces a new User Assigned Identity to be created."
  type        = string
  nullable    = false
}
variable "tags" {
  description = "(Optional) The Azure Tags to apply to all new resources. Defaults to `Null`."
  type        = map(string)
  default     = null
}
variable "enable_identity_credential" {
  description = "(Optional) Enable the Federated Identity. Defaults to `false`."
  type        = bool
  default     = false
}
variable "federated_identity_audience" {
  description = "(Optional) Specifies the audience for this Federated Identity Credential."
  type        = list(string)    
  default     = []
}
variable "federated_identity_issuer" {
  description = "(Optional) Specifies the issuer of this Federated Identity Credential."
  type        = string   
  default     = null
}
variable "federated_identity_subject" {
  description = "(Optional) Specifies the subject of this Federated Identity Credential."
  type        = string   
  default     = null
}
