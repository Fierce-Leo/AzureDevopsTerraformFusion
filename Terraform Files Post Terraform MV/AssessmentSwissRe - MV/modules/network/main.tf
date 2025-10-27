variable "rg_name" { type = string }
variable "location" { type = string }
variable "name_pref" { type = string }

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_pref}-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "app" {
  name                 = "${var.name_pref}-snet-app"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.KeyVault"
  ]
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}
