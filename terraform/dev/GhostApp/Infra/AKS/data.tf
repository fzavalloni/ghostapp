data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = "Terraform"
    storage_account_name = "ghospappterraform"
    container_name       = "ghostapp-statefile"
    key                  = "shared-statefile.tfstate"
    subscription_id      = "3b5f1238-e3ee-4a8d-93fa-6bb7f33c7233"
  }
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}