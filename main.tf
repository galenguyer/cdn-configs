# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  alias     = "sub2019"
  subscription_id = "a779aaef-4693-4c3a-bf68-6aa99ffe1acf"
  features {}
}

resource "azurerm_resource_group" "cdn" {
  provider = azurerm.sub2019
  name     = "cdn"
  location = "eastus"
}
