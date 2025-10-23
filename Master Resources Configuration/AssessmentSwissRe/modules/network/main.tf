variable "rg_name"  { type = string }
variable "location" { type = string }
variable "name_pref" { type = string }
variable "add_space" { type = string }
variable "sub_space" { type = string }

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_pref}-vnet"
  address_space       = [var.add_space]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "app" {
  name                 = "${var.name_pref}-snet-app"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.sub_space]

    service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.KeyVault"
  ]

  delegation {
  name = "webapp-delegation"

  service_delegation {
    name = "Microsoft.Web/serverFarms"
    actions = [
      "Microsoft.Network/virtualNetworks/subnets/action"
    ]
  }
}

}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}
