
# Service Abbreviations
variable "abbreviation" {
  default = ""
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
variable "instance_number" {
  default = ""
}

# Virtual Network Name
variable "virtual_network_name" {
  default = ""
}

# Address Prefixes
variable "address_prefixes" {
  default = []
}

# Resource Group
variable "resource_group_name" {
  default = ""
}

# Overrides
variable "name_override" {
  default = ""
}

# Toggles
variable "enforce_private_link_endpoint_network_policies" {
  default = false
}
variable "enforce_private_link_service_network_policies" {
  default = false
}

# Product Details
variable "service_endpoints" {
  default = null
}
variable "service_endpoint_policy_ids" {
  default = null
}
variable "delegation_service" {
  default = null
}
variable "delegation_name" {
  default = "delegation"
}
variable "delegation_actions" {
  default = []
}
variable "location_short_name" {
  default = ""
}
variable "workload" {
  default = ""
}


# Create a Subnet
#   Name format (scope: VNET, characters 1-80 [alphanumeric, _, ., -]):
resource "azurerm_subnet" "subnet" {
  # required
  name                                           = "${var.abbreviation}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = var.virtual_network_name
  address_prefixes                               = var.address_prefixes
  service_endpoints                              = var.service_endpoints
  service_endpoint_policy_ids                    = var.service_endpoint_policy_ids

  # optional
  # NOTE: this sets an delegation block and its service_delegation, only if the 'intrusion_detection' variable is set
  dynamic "delegation" {
    for_each = var.delegation_service != null ? [1] : []
    content {
      # required
      name = var.delegation_name
      service_delegation {
        # required
        name = var.delegation_service
        # optional
        actions = var.delegation_actions
      }
    }
  }
}

# Outputs
output "subnet" {
  value = azurerm_subnet.subnet
}
output "id" {
  value = azurerm_subnet.subnet.id
}
output "name" {
  value = azurerm_subnet.subnet.name
}