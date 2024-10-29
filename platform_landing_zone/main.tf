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

  # Comment out this backend for local deployments using PowerShell/VSCODE, leave it uncommented for use with Azure DevOps (ADO) pipelines
    backend "azurerm" {
    #  resource_group_name  = "rgocceus2prdtf001"  
    #  storage_account_name = "stocceus2prd001"
    #  container_name       = "terraform"
    #  key                  = "mg-platform-repo-occ-azure-infrastructure-eastus2.tfstate"
  }

  required_version = ">= 1.1.0"
}


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
variable "client_secret" {
  description = "Client Secret"
}

# Subscription IDs
variable "connectivity_subscription_id" {
  description = "Connectivity Subscription ID"
}
variable "identity_subscription_id" {
  description = "Identity Subscription ID"
}
variable "management_subscription_id" {
  description = "Management Subscription ID"
}

#--[ RESOURCE CONVENTIONS ]----------------------------------------------------------------------------------------------------------------

# Application, Subscription, Location, Environment, and Instance Number
# NOTE: these values are used to create names for resources and resource groups (please be mindful of character length limits)
variable "application_name" {
  description = "Application or Service Name"

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
    connectivity  = "conn"
    identity      = "iden"
    management    = "mgmt"
  }
}

#--[Firewall]

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

#--[ TOGGLES ]-----------------------------------------------------------------------------------------------------------------------------

variable "enable_connectivity_subscription"  {
  default = true 
}
variable "enable_identity_subscription"  {
  default = true 
}
variable "enable_management_subscription"  {
  default = true 
}



#--[ HIGH AVAILABILITY / FAILOVER ]--------------------------------------------------------------------------------------------------------

# Availability Zones
variable "zones" {
  type    = list
  default = [ "1", "2", "3" ]
}


#--[ SECURITY CENTER / DEFENDER FOR CLOUD ]------------------------------------------------------------------------------------------------

variable "enable_defender_plan_for_arm" {}
variable "enable_defender_plan_for_appServices" {}
variable "enable_defender_plan_for_virtualmachines" {}
variable "enable_defender_plan_for_containerregistry" {}
variable "enable_defender_plan_for_keyvault" {}
variable "enable_defender_plan_for_kubernetes" {}
variable "enable_defender_plan_for_sqlserver" {}
variable "enable_defender_plan_for_sqlservervm" {}
variable "enable_defender_plan_for_storage" {}
variable "enable_defender_plan_for_dns" {}
variable "email" {}
variable "phone" {}
variable "alert_notifications" {}
variable "alerts_to_admins" {}
variable "enable_vulnerability_assessment_auto_provision" {}
variable "enable_guest_configuration_agent_auto_provision" {}
variable "enable_log_analytics_auto_provision" {}
variable "identity_type" {}
variable "local_gtwy_pip" {}
variable "local_gtwy_cidr" {}
variable "gtwy_shared_key" {}

#--[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]------------------------------------------------------------------------------------------------

# Connectivity
variable "connectivity_vnet_address_space" {}
variable "gateway_subnet_address_prefixes" {}
variable "firewall_subnet_address_prefixes" {}
variable "azbastion_subnet_address_prefixes" {}
variable "firewall_mgmt_subnet_address_prefixes" {}

# Identity
variable "identity_vnet_address_space" {}
variable "iden_cmp_subnet_address_prefixes" {}
variable "iden_pvtlink_subnet_address_prefixes" {}


# Management
variable "management_vnet_address_space" {}
variable "mgmt_cmp_subnet_address_prefixes" {}
variable "mgmt_pvtlink_subnet_address_prefixes" {}

#Shared by Subs
variable "location_short_name" {}
variable "orgid" {}


#Routes
variable "udr_internet" {}
variable "udr_to_onprem_001" {}
variable "udr_to_onprem_002" {}
variable "udr_to_onprem_003" {}
variable "udr_to_onprem_004" {}
variable "udr_to_onprem_005" {}


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

variable "vm_admin_password" {
  type        = string
  description = "Password for DC Virtual Machines"
}

variable "dc_vm_details" {
  type = map(object({
    workload = string
    instance_number = string
    zone = string
  }))
  
}

variable "mgmt_vm_details" {
  type = map(object({
    workload = string
    instance_number = string
    zone = string
  }))
  
}



#==[ PROVIDERS ]===========================================================================================================================

# Connectivity Subscription
provider "azurerm" {
  alias           = "connectivity-sub"
  subscription_id = var.connectivity_subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Identity Subscription
provider "azurerm" {
  alias           = "identity-sub"
  subscription_id = var.identity_subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Management Subscription
provider "azurerm" {
  alias           = "management-sub"
  subscription_id = var.management_subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#==[ SUBSCRIPTION MODULES ]================================================================================================================

#--[ MANAGEMENT ]--------------------------------------------------------------------------------------------------------------------------
# NOTE: Management Subscription exports/outputs a Log Analytics Workspace used by all other subscriptions

module "management_subscription" {
  providers = {
    azurerm = azurerm.management-sub
  }
    source                                = "./subscriptions/management"
    count                                 = var.enable_management_subscription == true ? 1 : 0
    application_name                      = var.application_name
    subscription_type                     = local.subscription_types.management
    environment                           = var.environment
    location                              = var.location
    instance_number                       = var.instance_number
    tenant_id                             = var.tenant_id
    client_id                             = var.client_id
    client_secret                         = var.client_secret
    email                                 = var.email
    phone                                 = var.phone
    management_vnet_address_space         = var.management_vnet_address_space
    mgmt_pvtlink_subnet_address_prefixes  = var.mgmt_pvtlink_subnet_address_prefixes
    mgmt_cmp_subnet_address_prefixes      = var.mgmt_cmp_subnet_address_prefixes
    log_analytics_workspace_id            = module.management_subscription[0].log_analytics_workspace_id
    location_short_name                   = var.location_short_name
    orgid                                 = var.orgid
    mgmt_vm_details               = var.mgmt_vm_details
    vm_size                     = var.vm_size
    vm_username                 = var.vm_username
    vm_admin_password           = var.vm_admin_password

}

#--[ CONNECTIVITY ]------------------------------------------------------------------------------------------------------------------------

module "connectivity_subscription" {
  providers = {
    azurerm = azurerm.connectivity-sub
  }
  source = "./subscriptions/connectivity"
  count                                 = var.enable_connectivity_subscription == true ? 1 : 0
  application_name                      = var.application_name
  subscription_type                     = local.subscription_types.connectivity
  environment                           = var.environment
  location                              = var.location
  instance_number                       = var.instance_number
  tenant_id                             = var.tenant_id
  client_id                             = var.client_id
  client_secret                         = var.client_secret
  email                                 = var.email
  phone                                 = var.phone
  log_analytics_workspace_id            = module.management_subscription[0].log_analytics_workspace_id
  log_analytics_workspace_workspace_id  = module.management_subscription[0].log_analytics_workspace_workspace_id
  log_analytics_workspace_key           = module.management_subscription[0].log_analytics_workspace_key
  connectivity_vnet_address_space       = var.connectivity_vnet_address_space
  gateway_subnet_address_prefixes       = var.gateway_subnet_address_prefixes
  firewall_subnet_address_prefixes      = var.firewall_subnet_address_prefixes
  azbastion_subnet_address_prefixes     = var.azbastion_subnet_address_prefixes
  firewall_mgmt_subnet_address_prefixes = var.firewall_mgmt_subnet_address_prefixes
  location_short_name                   = var.location_short_name
  orgid                                 = var.orgid
  local_gtwy_pip                        = var.local_gtwy_pip
  local_gtwy_cidr                       = var.local_gtwy_cidr
  gtwy_shared_key                       = var.gtwy_shared_key
  iden_cmp_subnet_address_prefixes      = var.iden_cmp_subnet_address_prefixes
  mgmt_cmp_subnet_address_prefixes      = var.mgmt_cmp_subnet_address_prefixes
  depends_on                            = [ module.management_subscription ]
}


#--[ IDENTITY ]----------------------------------------------------------------------------------------------------------------------------

module "identity_subscription" {
  providers = {
    azurerm = azurerm.identity-sub
  }
  source                      = "./subscriptions/identity"
  count                       = var.enable_identity_subscription == true ? 1 : 0
  application_name            = var.application_name
  subscription_type           = local.subscription_types.identity
  environment                 = var.environment
  location                    = var.location
  instance_number             = var.instance_number
  tenant_id                   = var.tenant_id
  client_id                   = var.client_id
  client_secret               = var.client_secret
  email                       = var.email
  phone                       = var.phone
  vm_username                 = var.vm_username
  identity_vnet_address_space = var.identity_vnet_address_space
  iden_cmp_subnet_address_prefixes = var.iden_cmp_subnet_address_prefixes
  iden_pvtlink_subnet_address_prefixes = var.iden_pvtlink_subnet_address_prefixes
  log_analytics_workspace_id  = module.management_subscription[0].log_analytics_workspace_id
  location_short_name         = var.location_short_name
  orgid                       = var.orgid
  dc_vm_details               = var.dc_vm_details
  vm_size                     = var.vm_size
  vm_admin_password           = var.vm_admin_password
  default_network_security_group_rules = var. default_network_security_group_rules
  depends_on                  = [ module.management_subscription ]
}


# #=======================[ VIRTUAL NETWORK (VNET) PEERING ]==================================================================================================]]]]

# #--[ EastUS2 CONNECTIVITY  <-> EastUS2 Identity SPOKE ]--------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network_peering" "connectivity_hub-identity_spoke-peer" {
  name                         = "peer-connectivity-hub-identity-spoke"
  provider                     = azurerm.connectivity-sub
  resource_group_name          = module.connectivity_subscription[0].resource_group_name
  virtual_network_name         = module.connectivity_subscription[0].virtual_network_name
  remote_virtual_network_id    = module.identity_subscription[0].virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [ 
    module.connectivity_subscription, 
    module.identity_subscription
  ]
}

resource "azurerm_virtual_network_peering" "identity_spoke-connectivity_hub-peer" {
  name                         = "peer-identity-spoke-connectivity-hub"
  provider                     = azurerm.identity-sub
  resource_group_name          = module.identity_subscription[0].resource_group_name
  virtual_network_name         = module.identity_subscription[0].virtual_network_name
  remote_virtual_network_id    = module.connectivity_subscription[0].virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [
    module.connectivity_subscription, 
    module.identity_subscription
  ]
}

# #--[ EastUS2 Management SPOKE <-> EastUS2 CONNECTIVITY HUB ]--------------------------------------------------------------------------------------------------


resource "azurerm_virtual_network_peering" "management_spoke-connectivity_hub-peer" {
  name                         = "peer-management-spoke-connectivity-hub"
  provider                     = azurerm.management-sub
  resource_group_name          = module.management_subscription[0].resource_group_name
  virtual_network_name         = module.management_subscription[0].virtual_network_name
  remote_virtual_network_id    = module.connectivity_subscription[0].virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [
    module.connectivity_subscription, 
    module.management_subscription
  ]
}

resource "azurerm_virtual_network_peering" "connectivity_hub-management_spoke-peer" {
  name                         = "peer-connectivity-hub-management-spoke"
  provider                     = azurerm.connectivity-sub
  resource_group_name          = module.connectivity_subscription[0].resource_group_name
  virtual_network_name         = module.connectivity_subscription[0].virtual_network_name
  remote_virtual_network_id    = module.management_subscription[0].virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [ 
    module.connectivity_subscription, 
    module.management_subscription
  ]
}
