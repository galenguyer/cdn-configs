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
  subscription_id = "a779aaef-4693-4c3a-bf68-6aa99ffe1acf"
  features {}
}

resource "azurerm_resource_group" "cdn" {
  name     = "cdn"
  location = "East US"
}

resource "azurerm_traffic_manager_profile" "cdn-galenguyer" {
  name                = "cdn-galenguyer"
  resource_group_name = azurerm_resource_group.cdn.name

  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "galenguyer-cdn"
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
