

# Service Abbreviations
variable "abbreviation" {
  type    = string
  default = "ds"
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
variable "name" {
  type        = string
  description = "(Required) Diagnostics Setting Name"
  default     = "ds"
}
variable "resource_id" {
  type        = string
  description = "(Required) Resource ID of diagnotics to be enabled"
}

# Optional
variable "log_analytics_workspace_id" {
  type        = string
  description = "(Optional) Log Analytics Workspace ID where diagnotics will be logged to"
}
variable "retention_days" {
  default = 7
}
variable "logs_to_exclude" {
  default = []
}
variable "metrics_to_exclude" {
  default = []
}

# Get existing resource IDs for Azure Monitor diagnostic categories
data "azurerm_monitor_diagnostic_categories" "monitor_diagnostic_categories" {
  resource_id = var.resource_id
}

# Set Azure Monitor Diagnostic Settings
#   Name format (scope: service, characters: 1-80 [alphanumeric, _, -]): 
#     "<abbreviation>-<application_name>-<subscription_type>-<environment>-<location>-<instance_number>"
resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  # required
  name                        = var.name_override != "" ? var.name_override : "${var.abbreviation}-${var.application_name}-${var.subscription_type}-${var.environment}-${var.instance_number}"
  target_resource_id          = var.resource_id
  # optional
  log_analytics_workspace_id  = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.monitor_diagnostic_categories.logs)

    content {
      category = log.value
      enabled  = !(contains(var.logs_to_exclude, log.value))


    }
  }

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.monitor_diagnostic_categories.metrics)

    content {
      category = metric.value
      enabled  = !(contains(var.metrics_to_exclude, metric.value))


    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}

# Outputs
output "monitor_diagnostic_setting" {
  value = azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting
}
output "id" {
  value = azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting.id
}