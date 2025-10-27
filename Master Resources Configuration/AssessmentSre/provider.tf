terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
  }

#  backend "azurerm" {} #Uncomment it when running on Azure Devops using the given pipeline
}


provider "azurerm" {
  features {}
  subscription_id = "123"
  client_id       = "345"
  client_secret   = "678"
  tenant_id       = "910"
}
