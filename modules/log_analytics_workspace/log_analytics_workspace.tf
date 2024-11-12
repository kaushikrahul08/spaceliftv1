


# Service Abbreviations
variable "abbreviation" {
  default = "log"
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
  default = "PerGB2018"
}
variable "retention_in_days" {
  default = "365"
}

variable "orgid" {}
variable "workload" {}
variable "tags" {}
variable "location_short_name" {}

# Create a Log Analytics Workspace
#   Name format (scope: resource group, characters: 4-63 [alphanumeric, -]):
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  # required
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # optional
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags

lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

# Outputs
output "log_analytics_workspace" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace
}
output "id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
output "workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
}
output "primary_shared_key" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
}
output "name" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.name
}
output "location" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.location
}