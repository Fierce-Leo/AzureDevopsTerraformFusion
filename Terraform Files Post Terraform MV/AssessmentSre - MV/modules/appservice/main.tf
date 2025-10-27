variable "rg_name" { type = string }
variable "location" { type = string }
variable "name_pref" { type = string }
variable "sku_name" { type = string }
variable "subnet_id" { type = string }

variable "key_vault_id" { type = string }
variable "db_connection_string_secret_name" { type = string }

data "azurerm_key_vault_secret" "db_conn" {
  name         = var.db_connection_string_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.name_pref}-plan"
  location            = var.location
  resource_group_name = var.rg_name
  os_type             = "Windows"
  sku_name            = var.sku_name
}

resource "azurerm_windows_web_app" "app" {
  name                = "${var.name_pref}-web"
  location            = var.location
  resource_group_name = var.rg_name
  service_plan_id     = azurerm_service_plan.plan.id

  virtual_network_subnet_id = var.subnet_id

  site_config {
    always_on = true
    application_stack {
      dotnet_version = "v6.0"
    }
  }

  connection_string {
    name  = "dbconnection"
    type  = "SQLAzure"
    value = data.azurerm_key_vault_secret.db_conn.value
  }
}

output "webapp_name" { value = azurerm_windows_web_app.app.name }
