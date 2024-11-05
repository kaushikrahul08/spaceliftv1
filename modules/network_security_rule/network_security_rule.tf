# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.110.0"
#     }
#   }
#   required_version = ">= 1.1.0"
# }
# NOTE: Network Security Group Rules do not have a resource name, so the naming conventions and name_overrides are unnecessary
# # Service Abbreviations
# variable "abbreviation" {
#   default = "nsgsr"
# }

# # Naming Conventions
# variable "application_name" {
#   default = ""
# }
# variable "subscription_type" {
#   default = ""
# }
# variable "environment" {
#   default = ""
# }
# variable "location" {
#   default = ""
# }
# variable "instance_number" {
#   default = ""
# }

# # Overrides
# variable "name_override" {
#   default = ""
# }

# Required
variable "resource_group_name" {}
variable "network_security_group_name" {}
variable "network_security_group_rules" {
  description = "(Required) Network Security Group Rules to be applied"
}

# Create a Network Security Group Rule
#   Name format (scope: resource group, characters: 1-80 [alphanumeric, _, ., -]):
#     "<abbreviation>-<application_name>-<subscription_type>-<environment>-<location>-<instance_number>"
resource "azurerm_network_security_rule" "network_security_group_rule" {
  for_each                     = var.network_security_group_rules
  # required
  resource_group_name          = var.resource_group_name
  network_security_group_name  = var.network_security_group_name
  name                         = each.value.name
  # optional
  description                  = each.value.description
  direction                    = each.value.direction
  access                       = each.value.access
  priority                     = each.value.priority
  protocol                     = each.value.protocol
  source_port_range            = each.value.source_port_range
  source_port_ranges           = each.value.source_port_ranges
  destination_port_range       = each.value.destination_port_range
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefix        = each.value.source_address_prefix
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefix   = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
}

# Outputs
output "network_security_group_rule" {
  value = azurerm_network_security_rule.network_security_group_rule
}
# NOTE: for_each prevents output of a specific ID, but passing the entire resource call back makes it so the array can be traversed
# output "id" {
#   value = azurerm_network_security_rule.network_security_group_rule.id
# }