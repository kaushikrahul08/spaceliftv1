variable "resource_group_name" {}
variable "location" {}
variable "instance_number" {}
variable "tags" {}
variable "fw_ilb_private_ip" {
  default = "10.20.0.68"
}
variable "abbreviation" {
  default = "rt"
}
variable "orgid" {}
variable "workload" {}
variable "environment" {}
variable "location_short_name" {}

variable "route_prefixes" {
  description = "The list of address prefixes to use for each route."
}

variable "route_names" {
  description = "A list of public subnets inside the vNet."
  default     = ["udr"]
}

variable route_nexthop_types {
  description = "The type of Azure hop the packet should be sent to for each corresponding route.Valid values are 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'HyperNetGateway', 'None'"
  default     = ["VirtualAppliance"]
}

resource "azurerm_route_table" "route_table" {
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
   lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }  
}

resource "azurerm_route" "route" {
  name                   = "${var.route_names[count.index]}"
  resource_group_name    = var.resource_group_name
  route_table_name       = "${azurerm_route_table.route_table.name}"
  address_prefix         = "${var.route_prefixes[count.index]}"
  next_hop_type          = var.route_nexthop_types[0]
  next_hop_in_ip_address = var.fw_ilb_private_ip 
  count               = "${length(var.route_names)}"
}

# Outputs
output "route_table_id" {
  value = azurerm_route_table.route_table.id
}
