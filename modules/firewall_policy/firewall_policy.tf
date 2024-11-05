# Required Provider
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.110.0"
#     }
#   }
#   required_version = ">= 1.1.0"
# }


# Service Abbreviations
variable "abbreviation" {
  type    = string
  default = "fwpolicy"
}

# Naming Conventions
variable "application_name" {
  default = ""
}
variable "subscription_type" {
  default = ""
}
variable "environment" {
  default = ""
}
variable "location" {
  default = ""
}
variable "tags" {}
variable "instance_number" {
  default = ""
}

# Overrides
variable "name_override" {
  default = ""
}

# Required
variable "resource_group_name" {
  default = ""
}

# Optional
variable "sku" {
  type    = string
  default = "Standard"
}
variable "intrusion_detection_mode" {
  type    = string
  default = "on"
}
variable "dns_proxy_enabled" {
  type    = bool
  default = false
}
variable "dns_servers" {
  default = null
}
variable "orgid" {}
variable "workload" {}
variable "location_short_name" {}


resource "azurerm_firewall_policy" "firewall_policy" {
  # required
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  tags                  = var.tags
  # optional
  sku                   = var.sku

  # optional
  dns {
    # optional
    proxy_enabled         = var.dns_proxy_enabled
    servers               = var.dns_servers
  }
  threat_intelligence_mode = "Alert"

  # optional
  # NOTE: this sets an intrusion_detection block and its mode, only if the 'intrusion_detection' variable is set
  dynamic "intrusion_detection" {
    for_each = var.intrusion_detection_mode != "Off" ? [1] : []
    content {
      mode = var.intrusion_detection_mode
    }
  }
  lifecycle {
    ignore_changes = [threat_intelligence_mode,
    tags["CreatedOn"]]
    
  }
}

# Outputs
output "firewall_policy" {
  value = azurerm_firewall_policy.firewall_policy
}
output "id" {
  value = azurerm_firewall_policy.firewall_policy.id
}