
variable "resource_group_name" {}

variable "log_alert_description" {
  type        = string
  description = "The description of this activity log alert."
  default     = "This activity log alert is to monitor the health of all services in the given regions"
}

variable "log_alert_scopes" {
  type        = list
  description = "List of Scopes at which the Activity Log should be applied, for example a the Resource ID of a Subscription or a Resource (such as a Storage Account)."
}

variable "log_alert_enabled" {
  type        = bool
  description = "Should this Activity Log Alert be enabled? Defaults to true."
  default     = true
}

variable "criteria_category" {
  type        = string
  description = "The category of the operation. Possible values are Administrative, Autoscale, Policy, Recommendation, ResourceHealth, Security and ServiceHealth."
  default     = "ServiceHealth"
}

variable "service_health_events" {
  type        = list(string)
  description = "Events this alert will monitor Possible values are Incident, Maintenance, Informational, ActionRequired and Security. Defaults to all Events or Set to null to select all Events"
  default     = null
}

variable "service_health_locations" {
  type        = list(string)
  description = "Locations this alert will monitor. For example, West Europe. Defaults to centralus."
  default     = ["global"]
}

variable "service_health_services" {
  type        = list(string)
  description = "Services this alert will monitor. For example, Activity Logs & Alerts, Action Groups. Defaults to all Services or Set to null to select all Services."
  default     = null
}

variable "action_group_id" {
  type        = string
  description = "The ID of the Action Group can be sourced from the azurerm_monitor_action_group resource"
}

variable "webhook_properties" {
    type       = map
    default    = null
}

variable "abbreviation" {
  type    = string
  default = "logalt"
}

variable "orgid" {}
variable "workload" {}
variable "location_short_name" {
  default = "cus"
}
variable "environment" {}
variable "instance_number" {}
variable "location" {
  default = "global"
}
variable "tags" {}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name = var.resource_group_name
  scopes              = var.log_alert_scopes
  description         = var.log_alert_description
  enabled             = var.log_alert_enabled
  location            = var.location

  criteria {
    category = var.criteria_category

    service_health {
      events    = var.service_health_events
      locations = var.service_health_locations
      services  = var.service_health_services
    }
  }

  action {
    action_group_id     = var.action_group_id
    webhook_properties  = var.webhook_properties
  }

  tags = var.tags
  
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]  
}
}