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
  default     = "mgmt"
}
variable "environment" {
  description = "Environment: dev, test, prod,hub,spoke"
  default     = "spoke"
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

variable "log_alert_name" {
  default = "management_activity_log_alert"
}

variable "identity_type" {
  default = "SystemAssigned"
}

variable "enable_storageacc" {
   type    = bool
   default = false 
}

variable "enable_activity_log_alert" {
  type    = bool
   default = true 
 
}
variable "log_analytics_workspace_id" {}


variable "mgmt_vm_details" {
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

variable "vm_size" {}
variable "vm_admin_password" {
  type        = string
  description = "Password for DC Virtual Machines"
}


#--[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]------------------------------------------------------------------------------------------------

variable "management_vnet_address_space" {}
variable "mgmt_cmp_subnet_address_prefixes" {}
variable "mgmt_pvtlink_subnet_address_prefixes" {}

#==[ DATA ]================================================================================================================================

data "azurerm_subscription" "current" {}


#==[ LOCALS ]==============================================================================================================================

locals {
  application_names = {
        workload_type   = "mgmt"
        compute_snet    = "ComputeSubnet"
        pvtlink_snet    = "PrivatelinkSubnet"
        resource_group_log_alert = ["log"]
        log_alert_location       = "centralus"
        location_short_name      = "cus"
        kv_dns_zone_group_name   = "kvdnsgrpoccmgmt001"
        sa_dns_zone_group_name   = "sadnsgrpoccmgmt001"
        pes_conn_name_sa         = "connoccsamgmt001"
        pes_conn_name_kv         = "connocckviden001"
        subresource_names_sa     = ["blob"]
        subresource_names_kv     = ["Vault"]


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
variable "mgmt_rg_names" {
  default = ["mgmt","shrd"]
}
variable "location_short_name" {}

#==[ Resource Groups ]================================================================================================================================

module "resource_group" {
  source              = "../../../modules/resource_group"
  resource_group_names= var.mgmt_rg_names
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
  address_space       = var.management_vnet_address_space
}


# #--[ SUBNETs (SUBNET) ]--------------------------------------------------------------------------------------------------------------

module "compute_subnet" {
  source                = "../../../modules/subnet"
  workload              = local.application_names.compute_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.mgmt_cmp_subnet_address_prefixes
  depends_on            = [ module.virtual_network ]
}

module "pvtlink_subnet" {
  source                = "../../../modules/subnet"
  workload              = local.application_names.pvtlink_snet
  resource_group_name   = module.resource_group.rg_name_subs
  virtual_network_name  = module.virtual_network.name
  address_prefixes      = var.mgmt_pvtlink_subnet_address_prefixes
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

# #[  Storage Account ] ----------------------------------------------------------------------------------------------------------
module "storage_account" {
  source = "../../../modules/storage_account"
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
  source = "../../../modules/private_endpoint"
  location                      = var.location
  orgid                         = var.orgid
  environment                   = var.environment
  workload                      = local.application_names.workload_type
  location_short_name           = var.location_short_name
  resource_group_name           = module.resource_group.rg_name_shrd
  subresource_names             = local.application_names.subresource_names_sa
  private_connection_resource_id = module.storage_account.id
  private_service_connection_name = local.application_names.pes_conn_name_sa
  subnet_id                     = module.pvtlink_subnet.id
  tags                          = local.tags
  dns_zone_name                 = "privatelink.blob.core.windows.net"
  private_dns_zone_group_name   = local.application_names.sa_dns_zone_group_name
  instance_number               = "002"

}


# #--[ LOG ANALYTICS ]-----------------------------------------------------------------------------------------------------------------------

module "log_analytics_workspace" {
  source              = "../../../modules/log_analytics_workspace"
  location            = var.location
  orgid               = var.orgid
  environment         = var.environment
  workload            = local.application_names.workload_type
  instance_number     = var.instance_number
  location_short_name = var.location_short_name                        
  tags                = local.tags
  resource_group_name = module.resource_group.rg_name_shrd
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
  log_analytics_workspace_id                      = module.log_analytics_workspace.id
  identity_type                                   = var.identity_type
  location                                        = var.location
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

resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "VMInsights"
  location              = var.location
  resource_group_name   = module.resource_group.rg_name_shrd
  workspace_resource_id = module.log_analytics_workspace.id
  workspace_name        = module.log_analytics_workspace.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
  tags                      = local.tags
   lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}

resource "azurerm_monitor_action_group" "mgmt_action_group" {
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

module "management_activity_log_alert" {
  count                     = var.enable_activity_log_alert == true ? 1 : 0
  source                    = "../../../modules/monitor_activity_log_alert"
  orgid                     = var.orgid
  workload                  = local.application_names.workload_type
  environment               = var.environment
  instance_number           = var.instance_number                                     
  resource_group_name       = module.resource_group.rg_name_shrd
  log_alert_scopes          = [data.azurerm_subscription.current.id]
  log_alert_description     = "This activity log alert is to monitor the health of all services in the ${var.subscription_type} subsciption"
  log_alert_enabled         = true
  criteria_category         = "ServiceHealth"
  action_group_id           = azurerm_monitor_action_group.mgmt_action_group.id
  tags                      = local.tags
}


resource "azurerm_portal_dashboard" "management-board" {
  name                = "dashbrd${var.orgid}${local.application_names.workload_type}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name = module.resource_group.rg_name_shrd
  location            = var.location
  tags                = local.tags
   lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

  dashboard_properties = <<DASH
{
   "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "position": {
                        "x": 0,
                        "y": 0,
                        "rowSpan": 3,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/MarkdownPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "__Dashboard__\n\nThis dashboard is designed to have the basic information for your deployment.\n",
                                    "subtitle": "",
                                    "title": "Management subscription",
                                    "markdownSource": 1
                                }
                            }
                        }
                    }
                },               
                "1": {
                    "position": {
                        "x": 6,
                        "y": 0,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [
                          {
                            "name": "resourceType",
                            "value": "Microsoft.Resources/resources",
                            "isOptional": true
                          },
                          {
                            "name": "filter",
                            "isOptional": true
                          },
                          {
                            "name": "scope",
                            "isOptional": true
                          },
                          {
                            "name": "kind",
                            "isOptional": true
                          }
                        ],
                        "type": "Extension/HubsExtension/PartType/BrowseAllResourcesPinnedPart"
                    }
                }              
            }
        }
    },
    "metadata": {
        "model": {
            "timeRange": {
                "value": {
                    "relative": {
                        "duration": 24,
                        "timeUnit": 1
                    }
                },
                "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
            },
            "filterLocale": {
                "value": "en-us"
            },
            "filters": {
                "value": {
                    "MsPortalFx_TimeRange": {
                        "model": {
                            "format": "utc",
                            "granularity": "auto",
                            "relative": "24h"
                        },
                        "displayCache": {
                            "name": "UTC Time",
                            "value": "Past 24 hours"
                        },
                        "filteredPartIds": [
                            "StartboardPart-UnboundPart-ae44fef5-76b8-46b0-86f0-2b3f47bad1c7"
                        ]
                    }
                }
            }
        }
    }
}
DASH  
}

# #######################
# ##Routes
# ########################

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
  route_names         = ["udr-mgmt-to-internet"]
  tags                = local.tags
  fw_ilb_private_ip   = "10.20.0.68"
}

resource "azurerm_subnet_route_table_association" "comp_assoc" {
  subnet_id      = module.compute_subnet.id
  route_table_id = module.routes_fw.route_table_id
}

resource "azurerm_subnet_route_table_association" "pvt_assoc" {
  subnet_id      = module.pvtlink_subnet.id
  route_table_id = module.routes_fw.route_table_id
}

##--[Management VM]------------------------------------------------------------------------------------------------------------------------------------------------------

module "mgmt_vm" {
  source                = "../../../modules/windows_vm"
  resource_group_name   = module.resource_group.rg_name_shrd
  environment           = var.environment
  vm_details            = var.mgmt_vm_details
  location              = var.location
  admin_username        = var.vm_username
  admin_password        = var.vm_admin_password
  orgid                 = var.orgid
  location_short_name   = var.location_short_name
  subnet_id             = module.compute_subnet.id
  vm_size               = var.vm_size
  tags                  = local.tags
}


resource "azurerm_network_watcher" "netwatch" {
  name                = "nwoccmgmtprdeus001"
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


output "log_analytics_workspace_id" {
  value = module.log_analytics_workspace.id
}
output "log_analytics_workspace_workspace_id" {
  value = module.log_analytics_workspace.workspace_id
}
output "log_analytics_workspace_key" {
  value = module.log_analytics_workspace.primary_shared_key
}