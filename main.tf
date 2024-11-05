#==[ REQUIRED PROVIDERS ]==================================================================================================================

# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.110.0"
#     }
#     azuread = {
#       source  = "hashicorp/azuread"
#       version = "~> 2.15.0"
#     }
#   }

  # Comment out this backend for local deployments using PowerShell/VSCODE, leave it uncommented for use with Azure DevOps (ADO) pipelines

#   required_version = ">= 1.1.0"
# }


#==[ VARIABLES ]===========================================================================================================================

#--[ AZURE TENANT/CLIENT/SUBSCRIPTIONS ]---------------------------------------------------------------------------------------------------
# NOTE: no defaults are provided to ensure error or interactive prompt if not provided

# Azure Tenant ID
variable "tenant_id" {
  description = "Tenant ID"
}
# Service Principle (SPN) ID and Secret
variable "client_id" {
  description = "Client ID"
}


# Subscription IDs

variable "application_subscription_id" {
  description = "Management Subscription ID"
}

#--[ RESOURCE CONVENTIONS ]----------------------------------------------------------------------------------------------------------------

# Application, Subscription, Location, Environment, and Instance Number
# NOTE: these values are used to create names for resources and resource groups (please be mindful of character length limits)
variable "application_name" {
  description = "Application or Service Name"
  default = "test"

}
variable "subscription_type" {
  description = "Subscription Type: conn (connectivity), id (identity), mgmt (management)"
  default     = "shared"
}
variable "environment" {
  description = "Environment: dev, test, prod"

}
variable "location" {
  description = "Azure Location (see: https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#overview)"
  default     = "eastus2"
}

variable "instance_number" {
  description = "Instance Number: 001, 002, ..., 998, 999"
  default     = ["001"]
}

#--[ Localsags ]--------------------------------------------------------------------------------------------------------------------------------

locals {
  subscription_types = {
    application    = "app"
  }
}

#--[ TOGGLES ]-----------------------------------------------------------------------------------------------------------------------------

variable "enable_application_subscription"  {
  default = true 
}



#--[ HIGH AVAILABILITY / FAILOVER ]--------------------------------------------------------------------------------------------------------

# Availability Zones
variable "zones" {
  type    = list
  default = [ "1", "2", "3" ]
}



#--[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]------------------------------------------------------------------------------------------------

# Application 01
variable "app_vnet_address_space" {}
variable "app_cmp_subnet_address_prefixes" {}
variable "app_pvtlink_subnet_address_prefixes" {}


#--[ NETWORK SECURITY GROUP (NSG) RULES ]--------------------------------------------------------------------------------------------------

# All
variable "default_network_security_group_rules" {}


#--[ JUMPBOX / VM ]------------------------------------------------------------------------------------------------------------------------

variable "enable_jumpbox" {
  type        = bool
  description = "Controls the deployment of the Jump Box and its supporting infrastructure"
  default     = true
}
variable "vm_username" {
  type        = string
  description = "Username for Virtual Machines"
}

variable "vm_size" {}


variable "mgmt_vm_details" {
  type = map(object({
    workload = string
    instance_number = string
    zone = string
  }))
  
}
variable "location_short_name" {}
variable "orgid" {}



#==[ PROVIDERS ]===========================================================================================================================

# Management Subscription
provider "azurerm" {
  alias           = "application-sub"
  subscription_id = var.application_subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#==[ SUBSCRIPTION MODULES ]================================================================================================================

#--[ Application <01> ]--------------------------------------------------------------------------------------------------------------------------

module "application_subscription" {
  providers = {
    azurerm = azurerm.application-sub
  }
    source                                = "./subscriptions/application"
    count                                 = var.enable_application_subscription == true ? 1 : 0
    application_name                      = var.application_name
    subscription_type                     = local.subscription_types.application
    environment                           = var.environment
    location                              = var.location
    instance_number                       = var.instance_number
    tenant_id                             = var.tenant_id
    client_id                             = var.client_id
    app_vnet_address_space                = var.app_vnet_address_space
    app_cmp_subnet_address_prefixes       = var.app_cmp_subnet_address_prefixes
    app_pvtlink_subnet_address_prefixes   = var.app_pvtlink_subnet_address_prefixes
    location_short_name                   = var.location_short_name
    orgid                                 = var.orgid
    mgmt_vm_details                       = var.mgmt_vm_details
    vm_size                               = var.vm_size
    vm_username                           = var.vm_username


}



# #=======================[ VIRTUAL NETWORK (VNET) PEERING ]==================================================================================================]]]]

# #--[ EastUS2 CONNECTIVITY  <-> EastUS2 Identity SPOKE ]--------------------------------------------------------------------------------------------------

# resource "azurerm_virtual_network_peering" "connectivity_hub-identity_spoke-peer" {
#   name                         = "peer-connectivity-hub-identity-spoke"
#   provider                     = azurerm.connectivity-sub
#   resource_group_name          = module.connectivity_subscription[0].resource_group_name
#   virtual_network_name         = module.connectivity_subscription[0].virtual_network_name
#   remote_virtual_network_id    = module.identity_subscription[0].virtual_network_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = true
#   use_remote_gateways          = false
#   depends_on                   = [ 
#     module.connectivity_subscription, 
#     module.identity_subscription
#   ]
# }

# resource "azurerm_virtual_network_peering" "identity_spoke-connectivity_hub-peer" {
#   name                         = "peer-identity-spoke-connectivity-hub"
#   provider                     = azurerm.identity-sub
#   resource_group_name          = module.identity_subscription[0].resource_group_name
#   virtual_network_name         = module.identity_subscription[0].virtual_network_name
#   remote_virtual_network_id    = module.connectivity_subscription[0].virtual_network_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = true
#   depends_on                   = [
#     module.connectivity_subscription, 
#     module.identity_subscription
#   ]
# }

# #--[ EastUS2 Management SPOKE <-> EastUS2 CONNECTIVITY HUB ]--------------------------------------------------------------------------------------------------


# resource "azurerm_virtual_network_peering" "management_spoke-connectivity_hub-peer" {
#   name                         = "peer-management-spoke-connectivity-hub"
#   provider                     = azurerm.management-sub
#   resource_group_name          = module.management_subscription[0].resource_group_name
#   virtual_network_name         = module.management_subscription[0].virtual_network_name
#   remote_virtual_network_id    = module.connectivity_subscription[0].virtual_network_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = true
#   depends_on                   = [
#     module.connectivity_subscription, 
#     module.management_subscription
#   ]
# }

# resource "azurerm_virtual_network_peering" "connectivity_hub-management_spoke-peer" {
#   name                         = "peer-connectivity-hub-management-spoke"
#   provider                     = azurerm.connectivity-sub
#   resource_group_name          = module.connectivity_subscription[0].resource_group_name
#   virtual_network_name         = module.connectivity_subscription[0].virtual_network_name
#   remote_virtual_network_id    = module.management_subscription[0].virtual_network_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = true
#   use_remote_gateways          = false
#   depends_on                   = [ 
#     module.connectivity_subscription, 
#     module.management_subscription
#   ]
# }
