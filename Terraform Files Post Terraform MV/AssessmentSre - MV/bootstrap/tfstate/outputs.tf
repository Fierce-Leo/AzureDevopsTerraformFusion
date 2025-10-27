output "backend_rg_name" {
  value = azurerm_resource_group.rg.name
}
output "backend_storage_account_name" {
  value = azurerm_storage_account.sa.name
}
output "backend_container_name" {
  value = azurerm_storage_container.c.name
}

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}
output "sql_secret" {
  value = azurerm_key_vault_secret.sql_password.name
}
output "db_secret" {
  value = azurerm_key_vault_secret.db_conn.name
}
