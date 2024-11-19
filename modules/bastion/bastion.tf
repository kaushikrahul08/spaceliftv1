
# Service Abbreviations
variable "location" {
  default = ""
}
variable "bastion_host_name" {}
variable "bastion_ip_configuration_name" {
  default = null
}

# Required
variable "resource_group_name" {
  type        = string
  description = "(Required) Resource Group Name"
}
variable "ip_configuration_subnet_id" {
  # NOTE: The Subnet used for the Bastion Host must have the name 'AzureBastionSubnet' and 
  #   the subnet mask must be at least a '/26'.
  type        = string
  description = "(Required) Subnet ID for Bastion Host"
}
variable "ip_configuration_public_ip_address_id" {
  type        = string
  description = "(Required) Public IP Address ID to associate with Bastion Host"
}

# Optional
variable "sku" {
  type        = string
  description = "(Optional) The SKU for the Bastion Host (default: Basic, accepted: Basic, Standard)"
  default     = "Basic"
}
variable "copy_paste_enabled" {
  type        = bool
  description = "(Optional) Copy/Paste feature enabled for the Bastion Host (default: true)"
  default     = true
}
variable "file_copy_enabled" { # NOTE: requires 'sku' to be 'Standard'
  type        = bool
  description = "(Optional) Is File Copy feature enabled for the Bastion Host (default: false)"
  default     = false
}
variable "ip_connect_enabled" {
  type        = bool
  description = "(Optional) Is IP Connect feature enabled for the Bastion Host (default: false)"
  default     = false
}
variable "tags" {}

# Create a Bastion Host
#   Name format (scope: Resource Group, characters: 1-80 characters [alphanumeric, _, ., -]):
resource "azurerm_bastion_host" "bastion_host" {
  # required
  name                    = var.bastion_host_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  # optional
  sku                     = var.sku
  tags                    = var.tags
  # required
  ip_configuration {
    # required
    name                 = var.bastion_ip_configuration_name
    subnet_id            = var.ip_configuration_subnet_id
    public_ip_address_id = var.ip_configuration_public_ip_address_id
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

# Outputs
output "bastion_host" {
  value = azurerm_bastion_host.bastion_host
}
output "id" {
  value = azurerm_bastion_host.bastion_host.id
}
output "dns_name" {
  value = azurerm_bastion_host.bastion_host.dns_name
}