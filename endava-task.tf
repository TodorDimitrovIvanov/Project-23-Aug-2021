# Here we configure the Azure CLI authentication in Terraform:
# This configures Terraform to use the default Subscription defined in the Azure CLI
terraform {
  required_providers {
      azurerm = {
          source ="hashicorp/azurerm"
          version = "=2.46.0"
      }
  }
}

# Here we configure the Microsoft Azure Provider and authenticate using the Azure CLI
provider "azurerm" {
  features {}

  subscription_id = "4c36c606-dceb-478b-933a-2901049e3ab3"
  tenant_id       = "d5070288-ad0f-434d-b5c4-1452a421631f"
}