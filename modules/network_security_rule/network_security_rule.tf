

# Required
variable "resource_group_name" {}
variable "network_security_group_name" {}
variable "network_security_group_rules" {
  description = "(Required) Network Security Group Rules to be applied"
}

# Create a Network Security Group Rule
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