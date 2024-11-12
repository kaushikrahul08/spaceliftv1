#==[ REQUIRED PROVIDERS ]==================================================================================================================
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }

  required_version = ">= 1.1.0"
}


#==[ VARIABLES ]===========================================================================================================================

#--[ AZURE TENANT/CLIENT/SUBSCRIPTIONS ]---------------------------------------------------------------------------------------------------

# Azure Tenant ID
variable "tenant_id" {
  description = "Tenant ID"
}
variable "client_id" {
  description = "Client ID"
}


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
variable "environment" {
  description = "Environment: dev, qa,test, prod,hub,spoke,stage"
  default     = "dev"
}
variable "location" {
  description = "Azure Location (see: https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#overview)"
  default     = "eastus2"
}
variable "instance_number" {
  description = "Instance Number: 001, 002, ..., 998, 999"
  default     = ["001"]
}

variable "kv_sku_name" {
  default   = "standard"
}

#--[ HIGH AVAILABILITY / FAILOVER ]--------------------------------------------------------------------------------------------------------

# Availability Zones
variable "zones" {
  type    = list
  default = [ "1", "2", "3" ]
}

#--[ Virtual Machine]--------------------------------------------------------------------------------------------------------

variable "app_vm_details" {
  type = map(object({
    workload = string
    instance_number = string
    zone = string
  }))
  
}

variable "vm_username" {
  type        = string
  description = "Username for Fortigate Virtual Machines"
}

variable "vm_admin_password" {}
variable "vm_size" {}

variable "app_rg_names" {
  default = ["app","shrd"]
}
variable "location_short_name" {}
variable "orgid" {}

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

variable "app_vnet_address_space" {}
variable "app_cmp_subnet_address_prefixes" {}
variable "app_pvtlink_subnet_address_prefixes" {}

#==[ DATA ]================================================================================================================================

data "azurerm_subscription" "current" {}


#==[ LOCALS ]==============================================================================================================================

locals {
  application_names = {
        workload_type   = "app"
        compute_snet    = "ComputeSubnet"
        pvtlink_snet    = "PrivatelinkSubnet"
        resource_group_log_alert = ["log"]
        log_alert_location       = "centralus"
        location_short_name      = "cus"
        kv_dns_zone_group_name   = "kvdnsgrp${var.application_name}${var.subscription_type}${var.instance_number}"
        sa_dns_zone_group_name   = "sadnsgrp${var.application_name}${var.subscription_type}${var.instance_number}"
        sa_pes_conn_name         = "sapeconn${var.application_name}${var.subscription_type}${var.instance_number}"
        kv_pes_conn_name         = "kvpeconn${var.application_name}${var.subscription_type}${var.instance_number}"
        subresource_names_sa     = ["blob"]
        subresource_names_kv     = ["Vault"]


  }

  tags = {
    ApplicationName              = "LucernexApp"
    BusinessUnit                 = "Accruent"
    Environment                  = "${var.environment}"
    Owner                        = "App Department"
    CreatedOn                    = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    CreatedBy                    = "Spacelift Stack_${var.environment}"
}
}


#==[ Resource Groups ]================================================================================================================================

module "resource_group" {
  #count               = var.enable_rg == true ? 1 : 0
  source              = "../../modules/resource_group"
  resource_group_names= var.app_rg_names
  location            = var.location
  orgid               = var.orgid
  environment         = var.environment
  instance_number     = var.instance_number
  location_short_name = var.location_short_name                        
  tags                = local.tags
}


# # #--[ VIRTUAL NETWORK (VNET) ]--------------------------------------------------------------------------------------------------------------

module "virtual_network" {
  source              = "../../modules/virtual_network"
  resource_group_name = module.resource_group.rg_name_subs
  location            = var.location
  orgid               = var.orgid
  environment         = var.environment
  instance_number     = var.instance_number
  location_short_name = var.location_short_name                        
  tags                = local.tags
  workload            = local.application_names.workload_type
  address_space       = var.app_vnet_address_space
}


# # #--[ SUBNETs (SUBNET) ]--------------------------------------------------------------------------------------------------------------

module "compute_subnet" {
  source                = "../../modules/subnet"
  workload              = local.application_names.compute_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.app_cmp_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}

module "pvtlink_subnet" {
  source                = "../../modules/subnet"
  workload              = local.application_names.pvtlink_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.app_pvtlink_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}


# # #[  NSGs] ----------------------------------------------------------------------------------------------------------

module "network_security_group" {
  source              = "../../modules/network_security_group"
  orgid               = var.orgid
  environment         = var.environment
  location_short_name = var.location_short_name                        
  location            = var.location          
  instance_number     = var.instance_number  
  tags                = local.tags
  workload            = local.application_names.workload_type
  resource_group_name = module.resource_group.rg_name_subs
}

# # #[  Storage Account ] ----------------------------------------------------------------------------------------------------------
module "storage_account" {
  source = "../../modules/storage_account"
  orgid               = var.orgid
  environment         = var.environment
  location_short_name = var.location_short_name
  workload            = local.application_names.workload_type        
  location            = var.location
  instance_number     = var.instance_number
  resource_group_name = module.resource_group.rg_name_shrd
  tags                = local.tags
}

module "storage_pvtendpt" {
  source = "../../modules/private_endpoint"
  location                      = var.location
  orgid                         = var.orgid
  environment                   = var.environment
  workload                      = local.application_names.workload_type
  location_short_name           = var.location_short_name
  resource_group_name           = module.resource_group.rg_name_shrd
  subresource_names             = local.application_names.subresource_names_sa
  private_connection_resource_id = module.storage_account.id
  private_service_connection_name = local.application_names.sa_pes_conn_name
  subnet_id                     = module.pvtlink_subnet.id
  tags                          = local.tags
  dns_zone_name                 = "privatelink.blob.core.windows.net"
  private_dns_zone_group_name   = local.application_names.sa_dns_zone_group_name
  instance_number               = var.instance_number

}

# #--[ KEY VAULT ]---------------------------------------------------------------------------------------------------------------------------

module "key_vault" {
  count               = var.enable_keyvault == true ? 1 : 0
  source              = "../../modules/key_vault"
  orgid               = var.orgid
  environment         = var.environment
  instance_number     = var.instance_number
  location_short_name = var.location_short_name                        
  workload            = local.application_names.workload_type
  location            = var.location              
  tags                = local.tags
  resource_group_name = module.resource_group.rg_name_shrd
  sku_name            = var.kv_sku_name
}

module "keyvault_pvtendpt" {
  source = "../../modules/private_endpoint"
  location                      = var.location
  orgid                         = var.orgid
  environment                   = var.environment
  workload                      = local.application_names.workload_type
  location_short_name           = var.location_short_name
  resource_group_name           = module.resource_group.rg_name_shrd
  subresource_names             = local.application_names.subresource_names_kv
  private_connection_resource_id = module.key_vault[0].id
  private_service_connection_name = local.application_names.kv_pes_conn_name
  subnet_id                     = module.pvtlink_subnet.id
  tags                          = local.tags
  dns_zone_name                 = "privatelink.vaultcore.azure.net"
  private_dns_zone_group_name   = local.application_names.sa_dns_zone_group_name
  instance_number               = var.instance_number
}

# # #--[ LOG ANALYTICS ]-----------------------------------------------------------------------------------------------------------------------

module "log_analytics_workspace" {
  source              = "../../modules/log_analytics_workspace"
  location            = var.location
  orgid               = var.orgid
  environment         = var.environment
  workload            = local.application_names.workload_type
  instance_number     = var.instance_number
  location_short_name = var.location_short_name                        
  tags                = local.tags
  resource_group_name = module.resource_group.rg_name_shrd
}


resource "azurerm_log_analytics_solution" "security_center" {
  solution_name         = "SecurityCenterFree"
  location              = var.location
  resource_group_name   = module.resource_group.rg_name_shrd
  workspace_resource_id = module.log_analytics_workspace.id
  workspace_name        = module.log_analytics_workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree"
  }
  tags                      = local.tags
   lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}




# # #######################
# # ##Routes
# # ########################


# ##--[Application VMs]------------------------------------------------------------------------------------------------------------------------------------------------------

module "app_vm" {
  source                = "../../modules/windows_vm"
  resource_group_name   = module.resource_group.rg_name_shrd
  environment           = var.environment
  vm_details            = var.app_vm_details
  location              = var.location
  admin_username        = var.vm_username
  admin_password        = var.vm_admin_password
  orgid                 = var.orgid
  location_short_name   = var.location_short_name
  subnet_id             = module.compute_subnet.id
  vm_size               = var.vm_size
  tags                  = local.tags
}


# # #==[ OUTPUTS ]=============================================================================================================================
