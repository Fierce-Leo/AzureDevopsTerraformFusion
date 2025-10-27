variable "rg_name"  { type = string }
variable "location" { type = string }
variable "name_pref" { type = string }

variable "key_vault_id"                   { type = string }
variable "sql_admin_password_secret_name" { type = string }
variable "sku_name"                       { type = string }
variable "allow_azure_services"           { type = bool }

data "azurerm_key_vault_secret" "sql_password" {
  name         = var.sql_admin_password_secret_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_mssql_server" "server" {
  name                         = "${var.name_pref}-sqlsrv"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = data.azurerm_key_vault_secret.sql_password.value
  minimum_tls_version          = "1.2"
}

# Optionally allow Azure services
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  count            = var.allow_azure_services ? 1 : 0
  name             = "allow-azure-services"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "db" {
  name           = "${var.name_pref}-sqldb"
  server_id      = azurerm_mssql_server.server.id
  sku_name       = var.sku_name
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 5
}

output "server_name"   { value = azurerm_mssql_server.server.name }
output "database_name" { value = azurerm_mssql_database.db.name }
