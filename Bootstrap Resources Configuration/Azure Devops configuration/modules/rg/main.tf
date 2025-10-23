variable "region_key"   { type = string }
variable "location"     { type = string }
variable "project_pref" { type = string }

variable "sql_sku_name"        { type = string }
variable "appservice_sku_name" { type = string }
variable "storage_count"       { type = number }

variable "key_vault_id"                     { type = string }
variable "sql_admin_password_secret_name"   { type = string }
variable "db_connection_string_secret_name" { type = string }
variable "allow_azure_services_on_sql"      { type = bool }

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_pref}-${lower(var.region_key)}-rg"
  location = var.location
}

# Network (VNet + Subnet with Microsoft.Sql service endpoint)
module "network" {
  source     = "../network"
  rg_name    = azurerm_resource_group.rg.name
  location   = var.location
  name_pref  = "${var.project_pref}-${lower(var.region_key)}"
}

# SQL
module "sql" {
  source     = "../sql"
  rg_name    = azurerm_resource_group.rg.name
  location   = var.location
  name_pref  = "${var.project_pref}-${lower(var.region_key)}"

  key_vault_id                   = var.key_vault_id
  sql_admin_password_secret_name = var.sql_admin_password_secret_name
  sku_name                       = var.sql_sku_name
  allow_azure_services           = var.allow_azure_services_on_sql
}

# App Service
module "appservice" {
  source       = "../appservice"
  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  name_pref    = "${var.project_pref}-${lower(var.region_key)}"
  sku_name     = var.appservice_sku_name

  # VNet integration
  subnet_id    = module.network.app_subnet_id

  # Connection string from Key Vault (data fetched inside the module)
  key_vault_id                     = var.key_vault_id
  db_connection_string_secret_name = var.db_connection_string_secret_name
}

# Storage (N accounts per region)
module "storage" {
  source       = "../storage"
  rg_name      = azurerm_resource_group.rg.name
  location     = var.location
  name_pref    = "${var.project_pref}${lower(var.region_key)}"
  count_accounts = var.storage_count
}

# Expose a few useful outputs to root
output "rg_name"         { value = azurerm_resource_group.rg.name }
output "webapp_name"     { value = module.appservice.webapp_name }
output "sql_server_name" { value = module.sql.server_name }
output "sql_database_name" { value = module.sql.database_name }
