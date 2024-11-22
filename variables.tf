#==[ VARIABLES ]===========================================================================================================================

#--[ AZURE TENANT/CLIENT/SUBSCRIPTIONS ]---------------------------------------------------------------------------------------------------

# Azure Tenant ID
# variable "tenant_id" {
#   description = "Tenant ID"
# }
# variable "client_id" {
#   description = "Client ID"
# }


variable "application_name" {
  description = "Application or Service Name"
  default     = "lux"
}
variable "subscription_type" {
  description = "Subscription Type: app (Application), conn (connectivity), dt (devtest), id (identity), mgmt (management), prod (production)"
  default     = "app"
}
variable "APP_ENVIRONMENT" {
  description = "Environment: dev, qa,test, prod,hub,spoke,stage"
  default = "dv" #remove these when configured at Space-lift
  validation {
    condition = contains(["dv","tst","qa","uat","prod","dr"],var.APP_ENVIRONMENT)
    error_message = "Valid values for ENVIRONMENT are dv,tst,qa,uat,prod,dr"
  }
}

variable "APP_REGION" {
  description = "Azure Location (see: https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#overview)"
  default = "euz"  #remove these when configured at Space-lift
}

variable "instance_number" {
  description = "Instance Number: 001, 002, ..., 998, 999"
  default     = ["002"]
}


# Availability Zones
variable "zones" {
  type    = list
  default = [ "1", "2", "3" ]
}


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

# variable "kv_sku_name" {
#   default   = "standard"
# }

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