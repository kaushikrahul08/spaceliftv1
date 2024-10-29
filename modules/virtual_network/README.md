# Introduction 
Creates a virtual network with the following naming convention: vnet-(application_name)-(subscription_type)-(instance_number)

Exp: vnet-myapp-dev-1

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name      | Application or Service name used to build the virtual network name       |
| subscription_type   | Subscription type used to build the RG name        |
| resource_group_name           | The name of the resource group in which to create the virtual network.   |
| address_space           | The address space that is used the virtual network. You can supply more than one address space.   |
| location   | The Azure Region where the Resource Group should exist.        |
| bgp_community   | (Optional) The BGP community attribute in format <as-number>:<community-value>.        |
| dns_servers   | (Optional) List of IP addresses of DNS servers.        |
| edge_zone   | (Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist.        |
| flow_timeout_in_minutes   | (Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes.        |
| tags   | (Optional) A mapping of tags to assign to the resource.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| virtual_network_id   | The ID of the Virtual Network |
| virtual_network_name   | The Name of the Virtual Network |