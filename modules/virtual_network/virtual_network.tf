# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.110.0"
#     }
#   }
#   required_version = ">= 1.1.0"
# }

# Service Abbreviation
variable "abbreviation" {
  default = "vnet"
}

# Naming Conventions
variable "subscription_type" {
  default = ""
}
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
  default = ""
}
variable "orgid" {}
variable "location_short_name" {}
variable "workload" {}

# Required
variable "resource_group_name" {
  default = ""
}
variable "address_space" {
  default = ""
}

# Optional
variable "dns_servers" {
  default = null
}
variable "bgp_community" {
  default = null
}
variable "edge_zone" {
  default = null
}
variable "flow_timeout_in_minutes" {
  default = null
}
variable "tags" {}


# Create a Virtual Network (VNET)
#   Name format (scope: resource group, characters: 2-64 [alphanumerics, _, ., -]): 
resource "azurerm_virtual_network" "virtual_network" {
  # required
  name                    = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = var.address_space
  # optional
  dns_servers             = var.dns_servers
  bgp_community           = var.bgp_community
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  tags                    = var.tags

lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

# Outputs
output "virtual_network" {
  value = azurerm_virtual_network.virtual_network
}
output "id" {
  value = azurerm_virtual_network.virtual_network.id
}
output "name" {
  value = azurerm_virtual_network.virtual_network.name
}