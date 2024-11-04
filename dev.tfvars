
#==[ TOGGLES ]=============================================================================================================================


#==[ RESOURCE Naming CONVENTIONS ]================================================================================================================

application_name    = "lz"
subscription_type   = "shared"
environment         = "dev"
instance_number     = "001"
vm_size             = "Standard_D2ds_v5"
location_short_name = "eus2"
orgid               = "luc" 
#location            = "eastus2"

#==[ HIGH AVAILABILITY / FAILOVER ]========================================================================================================

# Availability Zones
zones = [ "1", "2", "3" ]


#==[ SECURITY CENTER / DEFENDER FOR CLOUD ]================================================================================================


#==[ Global Peering ]====================================================================================================================


#==[ VIRTUAL NETWORK AND SUBNET ADDRESSES ]================================================================================================

# # App Networking
app_vnet_address_space              = ["10.20.1.0/24"]
app_cmp_subnet_address_prefixes     = ["10.20.1.0/26"]
app_pvtlink_subnet_address_prefixes = ["10.20.1.64/26"]

#Routes address 



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