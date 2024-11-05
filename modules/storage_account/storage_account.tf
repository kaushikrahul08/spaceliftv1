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
  default = "st"
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

# Required
variable "resource_group_name" {
  default = ""
}

# Optional
variable "account_tier" {
  default = "Standard"
}
variable "account_replication_type" {
  default = "GRS"
}
variable "account_kind" {
  default = "StorageV2"
}
variable "access_tier" {
  default = "Hot"
}
variable "allow_nested_items_to_be_public" {
  default = false
}
variable "orgid" {}
variable "workload" {}
variable "tags" {}
variable "location_short_name" {}
variable "infrastructure_encryption_enabled" {
  default = true
}
variable "min_tls_version" {
  default = "TLS1_2"
  
}

# Create a Storage Account
#   Name format (scope: global , characters: 3-24 characters [lowercase letters and numbers]): 
resource "azurerm_storage_account" "storage_account" {
  # required
  name                              = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  # optional
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  account_kind                      = var.account_kind
  access_tier                       = var.access_tier
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  tags                              = var.tags
  min_tls_version                   = var.min_tls_version

  queue_properties  {
     logging {
         delete                = true
         read                  = true
         write                 = true
         version               = "1.0"
         retention_policy_days = 10
     }
   }

  lifecycle {
      ignore_changes = [
        tags["CreatedOn"]
      ]
    }

}

# Outputs
output "storage_account" {
  value = azurerm_storage_account.storage_account
}
output "name" {
  value = azurerm_storage_account.storage_account.name
}
output "id" {
  value = azurerm_storage_account.storage_account.id
}