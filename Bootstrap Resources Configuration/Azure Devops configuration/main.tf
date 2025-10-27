locals {
  regions = var.regions
}

# Key Vault data (shared)
data "azurerm_resource_group" "kv_rg" {
  name = var.key_vault_rg
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.kv_rg.name
}

# region composite module
module "region_resources" {
  for_each = var.regions
  source   = "./modules/rg"

  region_key   = each.key
  location     = each.value.location
  project_pref = var.project_prefix

  sql_sku_name        = try(each.value.sql_sku_name, "S0")
  appservice_sku_name = try(each.value.appservice_sku_name, "B1")
  storage_count       = try(each.value.storage_count, 4)

  key_vault_id                     = data.azurerm_key_vault.kv.id
  sql_admin_password_secret_name   = var.sql_admin_password_secret_name
  db_connection_string_secret_name = var.db_connection_string_secret_name
  allow_azure_services_on_sql      = var.allow_azure_services_on_sql
}
