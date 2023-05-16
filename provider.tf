terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.55.0"
    }
  }
}

provider "azurerm" {

  features {
  }
}

resource "azurerm_resource_group" "cloudaut-resource" {
  name     = "cloudaut-resource"
  location = "East US"

}