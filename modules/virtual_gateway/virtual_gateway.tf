# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.110.0"
#     }
#   }
#   required_version = ">= 1.1.0"
# }

# Service Abbreviations
variable "abbreviation" {
  default = "vgw"
}
variable "orgid" {}
variable "location_short_name" {}
variable "workload" {}
variable "location" {}
variable "environment" {}
variable "instance_number" {}
variable "vpn_gtwy_pip_id" {}
variable "vpn_gtwy_snet_id" {}
variable "resource_group_name" {}
variable "local_gtwy_pip" {}
variable "local_gtwy_cidr" {}
variable "gtwy_shared_key" {}
variable "tags" {}

resource "azurerm_virtual_network_gateway" "vpn_virtual_network_gateway" {
  name                            = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  type                            = "Vpn"
  vpn_type                        = "RouteBased"
  active_active                   = false
  enable_bgp                      = false
  sku                             = "VpnGw1"
  
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.vpn_gtwy_pip_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.vpn_gtwy_snet_id
  }
  tags                            = var.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }


}

resource "azurerm_local_network_gateway" "local_network_gateway" {
  name                = "lgw${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.local_gtwy_pip
  address_space       = var.local_gtwy_cidr
  tags                = var.tags

    lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }


}


resource "azurerm_virtual_network_gateway_connection" "gtwy_connection" {
  name                = "conn${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_virtual_network_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local_network_gateway.id

  shared_key = var.gtwy_shared_key
  tags       = var.tags

    lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}


# Outputs
output "id" {
  value = azurerm_virtual_network_gateway.vpn_virtual_network_gateway.id
}