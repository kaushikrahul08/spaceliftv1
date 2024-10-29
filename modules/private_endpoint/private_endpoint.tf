terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }
  required_version = ">= 1.1.0"
}

variable "subnet_id" {}
variable "resource_group_name" {}
variable "tags" {}
variable "subresource_names" {}
variable "private_connection_resource_id" {}
variable "private_service_connection_name" {}
variable "location" {}
variable "environment" {}
variable "private_dns_zone_group_name" {}
variable "dns_zone_name" {}

variable "orgid" {}
variable "location_short_name" {}
variable "workload" {}

variable "instance_number" {
  default = ""
}

# Service Abbreviation
variable "abbreviation" {
  default = "pe"
}



resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                  = var.dns_zone_name
  resource_group_name   = var.resource_group_name
  tags                  = var.tags
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = azurerm_private_dns_zone.private_dns_zone[*].id
  }
  tags              = var.tags
  
lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

  }
  


output "id" {
  value = azurerm_private_dns_zone.private_dns_zone[*].id
}
