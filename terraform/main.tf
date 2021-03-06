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
  subscription_id = "487440bc-ef01-495b-a83f-59f3af7900e9"
  features {}
}

resource "azurerm_resource_group" "cdn" {
  name     = "cdn"
  location = "East US"
}

resource "azurerm_traffic_manager_profile" "hg80" {
  name                = "hg80"
  resource_group_name = azurerm_resource_group.cdn.name

  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "hg80"
    ttl           = 60
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}
