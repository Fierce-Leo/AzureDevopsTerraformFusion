variable "regions" {
  description = "Map of regions to deploy. Keys are short codes; values contain Azure location names."
  type = map(object({
    location            = string
    sql_sku_name        = optional(string, "S0")
    appservice_sku_name = optional(string, "B1")
    storage_count       = optional(number, 4)
  }))
  default = {
    WE = {
      location            = "westeurope"
      sql_sku_name        = "S0"
      appservice_sku_name = "B1"
      storage_count       = 4
    }
    NS = {
      location            = "northeurope"
      sql_sku_name        = "S0"
      appservice_sku_name = "B1"
      storage_count       = 4
    }
  }
}

variable "project_prefix" {
  description = "Prefix used for resource names."
  type        = string
  default     = "webapp"
}

# Key Vault where secrets live
variable "key_vault_rg" {
  description = "Resource group containing the Key Vault."
  type        = string
  default     = "Chennai-DC-BCP"
}

variable "key_vault_name" {
  description = "Key Vault name."
  type        = string
  default     = "SreAssess-KV"
}

variable "sql_admin_password_secret_name" {
  description = "Secret name for SQL admin password."
  type        = string
  default     = "sql-admin-password"
}

variable "db_connection_string_secret_name" {
  description = "Secret name for the web app DB connection string."
  type        = string
  default     = "db-connection-string"
}

variable "allow_azure_services_on_sql" {
  description = "Allow Azure services to access SQL (minimal firewall rule)."
  type        = bool
  default     = true
}
