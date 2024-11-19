
#==[ VARIABLES ]===========================================================================================================================

#--[ AZURE TENANT/CLIENT/SUBSCRIPTIONS ]---------------------------------------------------------------------------------------------------

# Azure Tenant ID
# variable "tenant_id" {
#   description = "Tenant ID"
# }
# variable "client_id" {
#   description = "Client ID"
# }


#--[ RESOURCE CONVENTIONS ]----------------------------------------------------------------------------------------------------------------

# Application, Subscription, Location, Environment, and Instance Number
# NOTE: these values are used to create names for resources and resource groups (please be mindful of character length limits)
variable "application_name" {
  description = "Application or Service Name"
  default     = "lux"
}
variable "subscription_type" {
  description = "Subscription Type: app (Application), conn (connectivity), dt (devtest), id (identity), mgmt (management), prod (production)"
  default     = "app"
}
variable "ENVIRONMENT" {
  description = "Environment: dev, qa,test, prod,hub,spoke,stage"
}
variable "LOCATION" {
  description = "Azure Location (see: https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#overview)"
}
variable "instance_number" {
  description = "Instance Number: 001, 002, ..., 998, 999"
  default     = ["002"]
}

# variable "kv_sku_name" {
#   default   = "standard"
# }

#--[ HIGH AVAILABILITY / FAILOVER ]--------------------------------------------------------------------------------------------------------

# Availability Zones
variable "zones" {
  type    = list
  default = [ "1", "2", "3" ]
}

#--[ Virtual Machine]--------------------------------------------------------------------------------------------------------

# variable "app_vm_details" {
#   type = map(object({
#     workload = string
#     instance_number = string
#     zone = string
#   }))
  
# }

# variable "vm_username" {
#   type        = string
#   description = "Username for Fortigate Virtual Machines"
# }

# variable "vm_admin_password" {}
# variable "vm_size" {}

# variable "app_rg_names" {
#   default = ["app","shrd"]
# }
# variable "location_short_name" {}
# variable "orgid" {}

#--[ TOGGLES ]-----------------------------------------------------------------------------------------------------------------------------

variable "enable_rg" {
  type        = bool
  description = "Controls the deployment of the Rgs and its supporting infrastructure"
  default     = false
}

variable "enable_keyvault" {
  default     = true
  type        = bool

}
#--[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]------------------------------------------------------------------------------------------------

# variable "app_vnet_address_space" {}
# variable "app_cmp_subnet_address_prefixes" {}
# variable "app_pvtlink_subnet_address_prefixes" {}

#==[ DATA ]================================================================================================================================

data "azurerm_subscription" "current" {}


#==[ Resource Groups ]================================================================================================================================

module "resource_group" {
  source               = "./modules/resource_group"
  rg_name              = module.naming.rg_name_patterns[0]
  location             = var.LOCATION                 
  tags                 = local.tags
}
