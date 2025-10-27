variable "rg_name" { type = string }
variable "location" { type = string }
variable "name_pref" { type = string }
variable "count_accounts" { type = number }

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  special = false
  numeric = true
}

resource "azurerm_storage_account" "storage" {
  count                    = var.count_accounts
  name                     = lower(replace("${var.name_pref}${random_string.suffix.result}${format("%02d", count.index)}", "-", ""))
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
}
