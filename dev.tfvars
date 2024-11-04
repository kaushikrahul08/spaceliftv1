
#==[ TOGGLES ]=============================================================================================================================


#==[ RESOURCE CONVENTIONS ]================================================================================================================

# Application, Subscription, Location, Environment, and Instance Number
# NOTE: these values are used to create names for resources and resource groups (please be mindful of character length limits)
application_name    = "lz"
subscription_type   = "shared"
environment         = "dev"
#location            = "eastus2"
instance_number     = "001"
vm_size             = "Standard_D2ds_v5"

########
location_short_name = "eus2"
orgid               = "occ"       
#==[ HIGH AVAILABILITY / FAILOVER ]========================================================================================================

# Availability Zones
zones = [ "1", "2", "3" ]


#==[ SECURITY CENTER / DEFENDER FOR CLOUD ]================================================================================================

# enable_defender_plan_for_arm                    = false
# enable_defender_plan_for_virtualmachines        = false
# enable_defender_plan_for_containerregistry      = false
# enable_defender_plan_for_keyvault               = false
# enable_defender_plan_for_kubernetes             = false
# enable_defender_plan_for_sqlserver              = false
# enable_defender_plan_for_sqlservervm            = false
# enable_defender_plan_for_storage                = false
# enable_defender_plan_for_dns                    = false
# enable_defender_plan_for_appServices            = false
# email                                           = "rahulsharma@teksystems.com"
# phone                                           = "000-000-0000"
# alert_notifications                             = true
# alerts_to_admins                                = false
# enable_vulnerability_assessment_auto_provision  = false
# enable_log_analytics_auto_provision             = false
# enable_guest_configuration_agent_auto_provision = false
# identity_type                                   = "SystemAssigned"


#==[ Global Peering ]====================================================================================================================


#==[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]================================================================================================

# Connectivity Subscription
# connectivity_vnet_address_space         = ["10.20.0.0/24"]
# gateway_subnet_address_prefixes         = ["10.20.0.0/27"]
# firewall_subnet_address_prefixes        = ["10.20.0.64/26"]
# azbastion_subnet_address_prefixes       = ["10.20.0.128/26"]
# firewall_mgmt_subnet_address_prefixes   = ["10.20.0.192/26"]

#On-prem
# local_gtwy_pip = "205.170.185.82"
# local_gtwy_cidr = ["172.25.84.0/22"]


# # Identity Subscription
# identity_vnet_address_space              = ["10.20.1.0/24"]
# iden_cmp_subnet_address_prefixes         = ["10.20.1.0/26"]
# iden_pvtlink_subnet_address_prefixes     = ["10.20.1.64/26"]


# Management Subscription
management_vnet_address_space             = ["10.20.2.0/24"]
mgmt_cmp_subnet_address_prefixes          = ["10.20.2.0/26"]
mgmt_pvtlink_subnet_address_prefixes      = ["10.20.2.64/26"]

#Routes address 
# udr_internet = "0.0.0.0/0"

# udr_to_onprem_001 = "10.10.0.0/16"
# udr_to_onprem_002 = "10.50.0.0/16"
# udr_to_onprem_003 = "10.100.0.0/16"
# udr_to_onprem_004 = "10.200.0.0/16"
# udr_to_onprem_005 = "172.30.0.0/16"


#==[ NETWORK SECURITY GROUP (NSG) RULES ]==================================================================================================

# Default Rules
default_network_security_group_rules = {
  rule01 = {
    name                         = "Allowonpremise_ALL"
    description                  = null
    priority                     = 200
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = null
    destination_port_range       = "*"
    destination_port_ranges      = null
    source_address_prefix        = "172.25.84.0/22"
    source_address_prefixes      = null
    destination_address_prefix   = "*"
    destination_address_prefixes = null
  }
}
#####VMs
vm_username = "occadminvmuser"

mgmt_vm_details  = {
    "mgeus01"  = {
        workload        = "mgmt"
        instance_number = "001"
        zone            = "2"
    }

    }
# application_subscription_id = "bebb6b61-5ac1-4f45-9e8d-b64f895f94e9"
# client_id = "bc3d7c17-445e-49f8-84a9-9098f0e5d342"
# client_secret = ""
# tenant_id = "4863756e-7cb1-42c5-8f96-ca06fff29f9b"