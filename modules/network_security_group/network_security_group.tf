terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }
  required_version = ">= 1.1.0"
}


# Service Abbreviations
variable "abbreviation" {
  default = "nsg"
}

# Naming Conventions
variable "application_name" {
  default = ""
}
variable "orgid" {}
variable "workload" {}
variable "location_short_name" {}


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

# Required
variable "resource_group_name" {}

# Optional
variable "tags" {}

# Create a Network Security Group
#   Name format (scope: resource group, characters: 1-80 [alphanumeric, _, ., -]):
resource "azurerm_network_security_group" "network_security_group" {
  # required
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # optional
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

# Outputs
output "network_security_group" {
  value = azurerm_network_security_group.network_security_group
}
output "id" {
  value = azurerm_network_security_group.network_security_group.id
}
output "name" {
  value = azurerm_network_security_group.network_security_group.name
}
