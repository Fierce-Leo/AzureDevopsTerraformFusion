resource "azurerm_key_vault" "kv" {
  name                       = "${var.name_prefix}-${random_string.keysuffix.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "Set", "List", "Delete", "Recover", "Backup", "Restore"]
  }
}

resource "random_string" "keysuffix" {
  length  = 5
  upper   = false
  special = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  value        = "P@ssw0rd123!"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "db_conn" {
  name         = "db-connection-string"
  value        = "Server=mydb;Database=webapp;Uid=admin;Pwd=P@ssw0rd123!;"
  key_vault_id = azurerm_key_vault.kv.id
}
