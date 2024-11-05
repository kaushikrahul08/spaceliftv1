# TODO: Bring this module up to the standards of the other modules
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
  default = "nsgfl"
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

# Optional
variable "tags" {}


variable "enabled" {
  description = "(required)"
  type        = bool
  default     = "true"
}
variable "network_security_group_id" {
  description = "(required)"
  type        = string
}
variable "network_watcher_name" {
  description = "(required)"
  type        = string
}
variable "resource_group_name" {
  description = "(required)"
  type        = string
}
variable "storage_account_id" {
  description = "(required)"
  type        = string
}
variable "nsgflow_version" {
  description = "(optional)"
  type        = number
  default     = "2"
}
variable "retention_policy" {
  description = "nested block: NestingList, min items: 1, max items: 1"
  type = map(object(
    {
      days    = number
      enabled = bool
    }
  ))
}
variable "timeouts" {
  description = "nested block: NestingSingle, min items: 0, max items: 0"
  type = map(object(
    {
      create = string
      delete = string
      read   = string
      update = string
    }
  ))
  default = {}
}
variable "traffic_analytics" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = map(object(
    {
      enabled               = bool
      interval_in_minutes   = number
      workspace_id          = string
      workspace_region      = string
      workspace_resource_id = string
    }
  ))
}

resource "random_id" "id" {
  byte_length = 2
}

resource "azurerm_network_watcher_flow_log" "this" {
  enabled                   = var.enabled
  name                      = var.name_override != "" ? var.name_override : "${var.abbreviation}-${var.application_name}-${var.subscription_type}-${var.environment}-${var.location}-${var.instance_number}-${random_id.id.hex}"
  network_security_group_id = var.network_security_group_id
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.resource_group_name
  storage_account_id        = var.storage_account_id
  version                   = var.nsgflow_version

  dynamic "retention_policy" {
    for_each = var.retention_policy
    content {
      days    = retention_policy.value["days"]
      enabled = retention_policy.value["enabled"]
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      read   = timeouts.value["read"]
      update = timeouts.value["update"]
    }
  }

  dynamic "traffic_analytics" {
    for_each = var.traffic_analytics
    content {
      enabled               = traffic_analytics.value["enabled"]
      interval_in_minutes   = traffic_analytics.value["interval_in_minutes"]
      workspace_id          = traffic_analytics.value["workspace_id"]
      workspace_region      = traffic_analytics.value["workspace_region"]
      workspace_resource_id = traffic_analytics.value["workspace_resource_id"]
    }
  }
  lifecycle {
    ignore_changes = [location, tags]
  }
}