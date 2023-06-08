
terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform"
    storage_account_name = "ghospappterraform"
    container_name       = "ghostapp-statefile"
    key                  = "ghostapp-statefile.tfstate"
  }
}
