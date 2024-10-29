#==[ REQUIRED PROVIDERS ]==================================================================================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
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

# Service Principle (SPN) ID and Secret
variable "client_id" {
  description = "Client ID"
}
variable "client_secret" {
  description = "Client Secret"
}

#--[ RESOURCE CONVENTIONS ]----------------------------------------------------------------------------------------------------------------

# Application, Subscription, Location, Environment, and Instance Number
# NOTE: these values are used to create names for resources and resource groups (please be mindful of character length limits)
variable "application_name" {
  description = "Application or Service Name"
  default     = "demo"
}
variable "subscription_type" {
  description = "Subscription Type: conn (connectivity), dt (devtest), id (identity), mgmt (management), prod (production)"
  default     = "connectivity"
}
variable "environment" {
  description = "Environment: dev, test, prod"
  default     = "dev"
}
variable "location" {
  description = "Azure Location (see: https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/#overview)"
  default     = "eastus2"
}
variable "instance_number" {
  description = "Instance Number: 001, 002, ..., 998, 999"
  default     = "001"
}

variable "kv_sku_name" {
  default   = "premium"
}

#--[ HIGH AVAILABILITY / FAILOVER ]--------------------------------------------------------------------------------------------------------

# Availability Zones
variable "zones" {
  type    = list
  default = [ "1", "2", "3" ]
}


#--[ SECURITY CENTER / DEFENDER FOR CLOUD / LOG ANALYTICS ]--------------------------------------------------------------------------------

variable "email" {}
variable "phone" {}

variable "alerts_to_admins" {
  type    = bool
  default = false
}
variable "enable_asb_assignment" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_arm" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_appServices" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_virtualmachines" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_containerregistry" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_keyvault" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_kubernetes" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_sqlserver" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_sqlservervm" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_storage" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_dns" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_containers" {
  type    = bool
  default = false
}
variable "enable_defender_for_containers_auto_provision" {
  type    = bool
  default = false
}
variable "enable_guest_configuration_agent_auto_provision" {
  type    = bool
  default = false
}
variable "enable_vulnerability_assessment_auto_provision" {
  type    = bool
  default = false
}
variable "enable_diagnostic_settings" {
  type    = bool
  default = false
}
variable "enable_log_analytics_auto_provision" {
  type    = bool
  default = true
}

variable "alert_notifications" {
  type    = bool
  default = true
}
variable "enable_log_analytics_workspace" {
  description = "Controls the deployment of the log analytics workspace and its supporting infrastructure"
  default     = true
}
variable "log_alert_name" {
  default = "connectivity_activity_log_alert"
}

variable "log_analytics_workspace_key" {}
variable "log_analytics_workspace_id" {}
variable "log_analytics_workspace_workspace_id" {}

variable "identity_type" {
  default = "SystemAssigned"
}

variable "enable_firewall" {
  type        = bool
  description = "Controls the deployment of the Azure Firewall"
  default     = true
}

variable "enable_gateway" {
  type        = bool
  description = "Controls the deployment of the Gateway and its supporting infrastructure"
  default     = true

}

variable "enable_activity_log_alert" {
  type    = bool
   default = true 
 
}

#--[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]------------------------------------------------------------------------------------------------

variable "connectivity_vnet_address_space" {}
variable "gateway_subnet_address_prefixes" {}
variable "firewall_subnet_address_prefixes" {}
variable "azbastion_subnet_address_prefixes" {}
variable "firewall_mgmt_subnet_address_prefixes" {}

variable "iden_cmp_subnet_address_prefixes" {}
variable "mgmt_cmp_subnet_address_prefixes" {}


#--[ JUMPBOX / VM ]------------------------------------------------------------------------------------------------------------------------

variable "enable_jumpbox" {
  type        = bool
  description = "Controls the deployment of the Jump Box and its supporting infrastructure"
  default     = false
}

variable "local_gtwy_pip" {}
variable "local_gtwy_cidr" {}
variable "gtwy_shared_key" {}

#--[ KEY VAULT ]---------------------------------------------------------------------------------------------------------------------------

variable "enable_keyvault" {
  type        = bool
  description = "Controls the deployment of the keyvault and its supporting infrastructure"
  default     = true
}

#=======================================================================

# variable "application_rules" {
#   description = "List of application rules for the firewall policy"
#   type = list(object({
#     name              = string
#     priority          = number
#     rule_name         = string
#     source_addresses  = list(string)
#     target_fqdns      = list(string)
#   }))
# }

#==[ DATA ]================================================================================================================================

data "azurerm_subscription" "current" {}


#==[ LOCALS/TAGS ]==============================================================================================================================

locals {
  application_names = {
        workload_type   = "conn"
        gtwy_snet       = "GatewaySubnet"
        afw_snet        = "AzureFirewallSubnet"
        azbastion_snet  = "AzureBastionSubnet"
        afw_mgmt_snet   = "AzureFirewallManagementSubnet"
        resource_group_log_alert = ["log"]
        log_alert_location       = "centralus"
        location_short_name      = "cus"

  }

  tags = {
    ApplicationName              = "Landing Zone"
    BusinessUnit                 = "IT"
    Environment                  = "${var.environment}"
    Owner                        = "IT Department"
    CreatedOn                    = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    CreatedBy                    = "Terraform SPN"
  }

}

variable "orgid" {}
variable "conn_rg_names" {
  default = ["conn","shrd"]
}
variable "location_short_name" {}

#==[ Resource Groups ]================================================================================================================================

module "resource_group" {
  source              = "../../../modules/resource_group"
  resource_group_names= var.conn_rg_names
  location            = var.location
  orgid               = var.orgid
  environment         = var.environment
  instance_number     = var.instance_number
  location_short_name = var.location_short_name
  tags                = local.tags
}

# #--[ VIRTUAL NETWORK (VNET) ]--------------------------------------------------------------------------------------------------------------

module "virtual_network" {
  source              = "../../../modules/virtual_network"
  resource_group_name = module.resource_group.rg_name_subs
  location            = var.location
  orgid               = var.orgid
  environment         = var.environment
  instance_number     = var.instance_number
  location_short_name = var.location_short_name                        
  tags                = local.tags
  workload            = local.application_names.workload_type
  address_space       = var.connectivity_vnet_address_space
}

# #--[ SUBNETs (SUBNET) ]--------------------------------------------------------------------------------------------------------------

module "gateway_subnet" {
  source                = "../../../modules/subnet"
  workload              = local.application_names.gtwy_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.gateway_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}

module "firewall_subnet" {
  source                = "../../../modules/subnet"
  workload              = local.application_names.afw_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.firewall_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}

module "firewall_mgmt_subnet" {
  source                = "../../../modules/subnet"
  workload              = local.application_names.afw_mgmt_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.firewall_mgmt_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}


module "bastion_subnet" {
  source                = "../../../modules/subnet"
  workload              = local.application_names.azbastion_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.azbastion_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}


# #[  NSGs] ----------------------------------------------------------------------------------------------------------

module "network_security_group" {
  source              = "../../../modules/network_security_group"
  orgid               = var.orgid
  environment         = var.environment
  location_short_name = var.location_short_name                        
  location            = var.location          
  instance_number     = var.instance_number  
  tags                = local.tags
  workload            = local.application_names.workload_type
  resource_group_name = module.resource_group.rg_name_subs
}
# #-- [ Bastion]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module "public_ip_bastion" {
  source                = "../../../modules/public_ip"
  environment           = var.environment
  orgid                 = var.orgid
  location_short_name   = var.location_short_name                        
  workload              = "bstn"   
  location              = var.location         
  instance_number       = var.instance_number  
  tags                  = local.tags
  resource_group_name   = module.resource_group.rg_name_shrd
  allocation_method     = "Static"
  sku                   = "Standard"
}

module "bastion_host" {
  source                                = "../../../modules/bastion"
  orgid                                 = var.orgid
  location_short_name                   = var.location_short_name                        
  workload                              = "bstn"   
  environment                           = var.environment              
  location                              = var.location          
  instance_number                       = var.instance_number  
  tags                                  = local.tags
  resource_group_name                   = module.resource_group.rg_name_shrd
  ip_configuration_subnet_id            = module.bastion_subnet.id
  ip_configuration_public_ip_address_id = module.public_ip_bastion.id
  depends_on                            = [ 
    module.virtual_network, 
    module.bastion_subnet 
  ]
}


# #-- [ VPN Gateway]-----------------------------------------------------------------------------------------------------------------------

module "public_ip_vpn_gateway" {
  count                 = var.enable_gateway == true ? 1 : 0
  source                = "../../../modules/public_ip"
  environment           = var.environment
  orgid                 = var.orgid
  location_short_name   = var.location_short_name                        
  workload              = "gtwy"   
  location              = var.location         
  instance_number       = var.instance_number  
  tags                  = local.tags
  resource_group_name   = module.resource_group.rg_name_subs
  allocation_method     = "Static"
  sku                   = "Standard"
}

module "vpn_gateway" {
  count                 = var.enable_gateway == true ? 1 : 0
  source                = "../../../modules/virtual_gateway"
  environment           = var.environment
  orgid                 = var.orgid
  location_short_name   = var.location_short_name                        
  workload              = local.application_names.workload_type   
  location              = var.location         
  instance_number       = var.instance_number  
  tags                  = local.tags
  resource_group_name   = module.resource_group.rg_name_subs
  vpn_gtwy_pip_id       = module.public_ip_vpn_gateway[0].id
  vpn_gtwy_snet_id      = module.gateway_subnet.id
  local_gtwy_pip        = var.local_gtwy_pip
  local_gtwy_cidr       = var.local_gtwy_cidr
  gtwy_shared_key       = var.gtwy_shared_key
}


# #--[ Firewall ]------------------------------------------------------------------------------------------------------------------------------------

module "firewall_policy" {
  count                     = var.enable_firewall == true ? 1 : 0
  source                    = "../../../modules/firewall_policy"
  environment               = var.environment                             
  location                  = var.location
  location_short_name       = var.location_short_name                        
  orgid                     = var.orgid
  instance_number           = var.instance_number                                     
  resource_group_name       = module.resource_group.rg_name_subs
  workload                  = local.application_names.workload_type
  sku                       = "Standard"     
  intrusion_detection_mode  = "Off" # NOTE: "Alert" requires the sku to be set to "Premium"
  dns_proxy_enabled         = false
  dns_servers               = null
  tags                      = local.tags
  depends_on                = [ module.firewall_subnet ]

}

module "public_ip_fw" {
  count                 = var.enable_firewall == true ? 1 : 0
  source                = "../../../modules/public_ip"
  environment           = var.environment
  orgid                 = var.orgid
  location_short_name   = var.location_short_name                        
  workload              = "afw"   
  location              = var.location         
  instance_number       = var.instance_number  
  tags                  = local.tags
  resource_group_name   = module.resource_group.rg_name_subs
  allocation_method     = "Static"
  sku                   = "Standard"
}


resource "azurerm_firewall" "az_fw" {
  count               = var.enable_firewall == true ? 1 : 0
  name                = "afw${var.orgid}${local.application_names.workload_type}${var.environment}${var.location_short_name}${var.instance_number}"
  location            = var.location
  resource_group_name = module.resource_group.rg_name_subs
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet"
  firewall_policy_id  = module.firewall_policy[0].id
  tags                = local.tags
  
  ip_configuration {
  name                 = "ip_config"
  subnet_id            = module.firewall_subnet.id
  public_ip_address_id = module.public_ip_fw[0].id
}

  lifecycle {
      ignore_changes = [
        tags["CreatedOn"]
      ]
}
  depends_on          = [ module.firewall_policy ]
}

resource "azurerm_firewall_policy_rule_collection_group" "fwpolrcg" {
  count               = var.enable_firewall == true ? 1 : 0
  name               = "fwrul-${var.orgid}${local.application_names.workload_type}${var.environment}${var.location_short_name}${var.instance_number}"
  firewall_policy_id = module.firewall_policy[0].id
  priority           = 100
  
  network_rule_collection {
    name     = "network_rule_collection_100"
    priority = 100
    action   = "Allow"
    
    rule {
      name                  = "AllowBastion"
      protocols             = ["TCP","UDP"]
      source_addresses      = var.azbastion_subnet_address_prefixes
      destination_addresses = var.firewall_subnet_address_prefixes 
      destination_ports     = ["5701", "8080"]
    }
    rule {
      name                  = "AllowReverseBastion"
      protocols             = ["TCP","UDP"]
      source_addresses      = var.firewall_subnet_address_prefixes 
      destination_addresses = var.azbastion_subnet_address_prefixes
      destination_ports     = ["5701", "8080"]
    }
  
  }

  depends_on                = [ module.firewall_policy ]

lifecycle {
    ignore_changes = [
      network_rule_collection,application_rule_collection]
  }

  
}


# #--[ SECURITY CENTER / DEFENDER FOR CLOUD ]------------------------------------------------------------------------------------------------

module "security_center" {
  source                                          = "../../../modules/security_center"
  client_id                                       = var.client_id
  client_secret                                   = var.client_secret
  enable_asb_assignment                           = var.enable_asb_assignment
  enable_defender_plan_for_arm                    = var.enable_defender_plan_for_arm
  enable_defender_plan_for_appServices            = var.enable_defender_plan_for_appServices
  enable_defender_plan_for_virtualmachines        = var.enable_defender_plan_for_virtualmachines
  enable_defender_plan_for_containerregistry      = var.enable_defender_plan_for_containerregistry
  enable_defender_plan_for_keyvault               = var.enable_defender_plan_for_keyvault
  enable_defender_plan_for_kubernetes             = var.enable_defender_plan_for_kubernetes
  enable_defender_plan_for_sqlserver              = var.enable_defender_plan_for_sqlserver
  enable_defender_plan_for_sqlservervm            = var.enable_defender_plan_for_sqlservervm
  enable_defender_plan_for_storage                = var.enable_defender_plan_for_storage
  enable_defender_plan_for_dns                    = var.enable_defender_plan_for_dns
  enable_defender_plan_for_containers             = var.enable_defender_plan_for_containers
  enable_log_analytics_auto_provision             = var.enable_log_analytics_auto_provision
  enable_vulnerability_assessment_auto_provision  = var.enable_vulnerability_assessment_auto_provision
  enable_guest_configuration_agent_auto_provision = var.enable_guest_configuration_agent_auto_provision
  enable_defender_for_containers_auto_provision   = var.enable_defender_for_containers_auto_provision
  enable_diagnostic_settings                      = var.enable_diagnostic_settings
  email                                           = var.email
  phone                                           = var.phone
  alert_notifications                             = var.alert_notifications
  alerts_to_admins                                = var.alerts_to_admins
  log_analytics_workspace_resource_group_name     = module.resource_group.rg_name_shrd
  log_analytics_workspace_id                      = var.log_analytics_workspace_id
  identity_type                                   = var.identity_type
  location                                        = var.location
}

resource "azurerm_monitor_action_group" "connectivity_action_group" {
  name                = "actiongrp${var.orgid}${local.application_names.workload_type}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name = module.resource_group.rg_name_shrd
  short_name          = "${var.subscription_type}"
  email_receiver {
    name                    = "sendtodevops"
    email_address           = var.email
    use_common_alert_schema = true
  }
  tags                      = local.tags
   
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}

module "connectivity_activity_log_alert" {
  count                     = var.enable_activity_log_alert == true ? 1 : 0
  source                    = "../../../modules/monitor_activity_log_alert"
  orgid                     = var.orgid
  workload                  = local.application_names.workload_type
  environment               = var.environment
  instance_number           = var.instance_number                                     
  resource_group_name       = module.resource_group.rg_name_shrd
  log_alert_scopes          = [data.azurerm_subscription.current.id]
  log_alert_description     = "This activity log alert is to monitor the health of all services in the ${var.subscription_type} subscription"
  log_alert_enabled         = true
  criteria_category         = "ServiceHealth"
  action_group_id           = azurerm_monitor_action_group.connectivity_action_group.id
  tags                      = local.tags
}

# # -- [Routes]----------------------------------------------------------------------------------------------------

module "routes_fw" {
  source              = "../../../modules/routes"
  instance_number     = var.instance_number
  orgid               = var.orgid
  workload            = local.application_names.workload_type
  environment         = var.environment
  location_short_name = var.location_short_name
  resource_group_name = module.resource_group.rg_name_shrd
  location            = var.location
  route_prefixes      = ["0.0.0.0/0"]
  route_names         = ["udrocctesttointernet"]
  tags                = local.tags
  fw_ilb_private_ip   = "10.20.0.68"
}


resource "azurerm_network_watcher" "netwatch" {
  name                = "nwoccconnprdeus001"
  location            = var.location
  resource_group_name = module.resource_group.rg_name_shrd
  tags                = local.tags

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }


}

# #==[ OUTPUTS ]=============================================================================================================================

output "resource_group_name" {
  value = module.resource_group.rg_name_subs
}
output "virtual_network_name" {
  value = module.virtual_network.name
}
output "virtual_network_id" {
  value = module.virtual_network.id
}

