variable "rg_name" { type = string }
variable "location" { type = string }
variable "name_pref" { type = string }
variable "subnet_id" { type = string }
variable "webapp_fqdn" { type = string }

resource "azurerm_public_ip" "agw_pip" {
  name                = "${var.name_pref}-agw-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "${var.name_pref}-waf-policy"
  resource_group_name = var.rg_name
  location            = var.location

  policy_settings {
    enabled                     = true
    mode                       = "Prevention"
    request_body_check         = true
    file_upload_limit_in_mb    = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "agw" {
  name                = "${var.name_pref}-agw"
  resource_group_name = var.rg_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf.id

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name  = "webapp-backend-pool"
    fqdns = [var.webapp_fqdn]
  }

  backend_http_settings {
    name                  = "webapp-backend-settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "webapp-backend-pool"
    backend_http_settings_name = "webapp-backend-settings"
    priority                   = 100
  }
}

output "public_ip_address" { value = azurerm_public_ip.agw_pip.ip_address }
output "agw_name" { value = azurerm_application_gateway.agw.name }