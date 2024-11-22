
# Service Abbreviation
variable "abbreviation" {
  default = "rg"
}

variable "location" {
  default = ""
}

variable "rg_name" {}

# Optional
variable "tags" {}

resource "azurerm_resource_group" "resource_group" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags

lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}

# Outputs
output "resource_group" {
  value = azurerm_resource_group.resource_group
}
output "id" {
  value = azurerm_resource_group.resource_group.id
}
output "name" {
  value = azurerm_resource_group.resource_group.name
}
output "location" {
  value = azurerm_resource_group.resource_group.location
}
