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
  subscription_id = "1238fe66-60d9-4798-b45b-5cfe98263fd1"
  tenant_id       = "8a246d4e-80d4-4a03-968c-b9e56568f343"
  client_id       = "8ec7ba7e-7961-4747-9ef8-f34062e9177e"
  client_secret   = "SECRET"
}
