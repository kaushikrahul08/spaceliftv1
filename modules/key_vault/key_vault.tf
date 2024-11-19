

variable "abbreviation" {
  default = "kv"
}

variable "location" {
  default = ""
}

# Required 
variable "resource_group_name" {
  default = ""
}
variable "sku_name" {}

# Optional
variable "tags" {}
variable "enabled_for_deployment" {
  default = false
}
variable "enabled_for_disk_encryption" {
  default = false
}
variable "enabled_for_template_deployment" {
  default = false
}
variable "enable_rbac_authorization" {
  default = true
}
variable "purge_protection_enabled" {
  default = true
}
variable "soft_delete_retention_days" {
  default = 7
}

variable "orgid" {}
variable "location_short_name" {}
variable "workload" {}
variable "environment" {}
variable "instance_number" {}
variable "kv_name" {}


# Get current client configuration from azurerm provider
data "azurerm_client_config" "current" {}

# Create a Key Vault
#   Name format (scope: global, characters: 3-24 [alphanumerics, -]): 
resource "azurerm_key_vault" "key_vault" {
  # required
  name                            = var.kv_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku_name                        = var.sku_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id # current tenant_id from azurerm provider
  # optional
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  tags                            = var.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  # Optional if Azure policies are forced to use RBAC
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id 

    key_permissions = [
      "Get","Create","List",
    ]

    secret_permissions = [
      "Get","Set","List",
    ]

  }

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
      network_acls

    ]
  }
}

# Outputs
output "key_vault" {
  value = azurerm_key_vault.key_vault
}
output "id" {
  value = azurerm_key_vault.key_vault.id
}
output "vault_uri" {
  value = azurerm_key_vault.key_vault.vault_uri
}