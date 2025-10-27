output "resource_groups" {
  value = { for k, v in module.region_resources : k => v.rg_name }
}

output "webapps" {
  value = { for k, v in module.region_resources : k => v.webapp_name }
}

output "sql_servers" {
  value = { for k, v in module.region_resources : k => v.sql_server_name }
}

output "sql_databases" {
  value = { for k, v in module.region_resources : k => v.sql_database_name }
}

output "application_gateway_ips" {
  value = { for k, v in module.region_resources : k => v.agw_public_ip }
}
