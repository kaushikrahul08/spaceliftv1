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
  default = "pip"
}

# Naming Conventions

variable "environment" {
  default = ""
}
variable "location" {
  default = ""
}
variable "instance_number" {
  default = ""
}

# Overrides
variable "name_override" {
  default = null
}

# Requirements
variable "resource_group_name" {
  default = ""
}
variable "allocation_method" {
  default = "Static"
}

# Optionals
variable "sku" {
  default = "Standard"
}
variable "sku_tier" {
  default = "Regional"
}
variable "ip_version" {
  default = null
}
variable "ip_tags" {
  default = null
}
variable "tags" {}
variable "reverse_fqdn" {
  default = null
}
variable "public_ip_prefix_id" {
  default = null
}
variable "idle_timeout_in_minutes" {
  default = 15
}
variable "zones" {
  default = []
}
variable "edge_zone" {
  default = null
}
variable "domain_name_label" {
  default = null
}

variable "orgid" {}
variable "location_short_name" {}
variable "workload" {}


# Create a Public IP Address
#   Name format (scope: Resource Group, characters: 1-80 characters [alphanumeric, _, ., -]):
resource "azurerm_public_ip" "public_ip" {
  # required
  name                    = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name     = var.resource_group_name
  location                = var.location
  allocation_method       = var.allocation_method
  # optional
  sku                     = var.sku
  sku_tier                = var.sku_tier
  ip_version              = var.ip_version
  ip_tags                 = var.ip_tags
  tags                    = var.tags
  reverse_fqdn            = var.reverse_fqdn
  public_ip_prefix_id     = var.public_ip_prefix_id
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
  edge_zone               = var.edge_zone
  domain_name_label       = var.domain_name_label

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

# Outputs
output "id" {
  value = azurerm_public_ip.public_ip.id
}
output "ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
output "fqdn" {
  value = azurerm_public_ip.public_ip.fqdn
}
output "name" {
  value = azurerm_public_ip.public_ip.name
}