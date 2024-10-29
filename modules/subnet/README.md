# Introduction 
Creates a subnet with the following naming convention: snet-(application_name)-(subscription_type)-(instance_number)

Exp: snet-myapp-dev-01

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name      | Application or Service name used to build the RG name       |
| subscription_type   | Subscription type used to build the RG name        |
| instance_number   | Instance number used to build the subnet name        |
| location   | The Azure Region where the subnet exists.        |
| resource_group_name           | Specifies the Resource Group where the Network Watcher should exist.   |
| virtual_network_name           | The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.   |
| address_prefixes           | The address prefixes to use for the subnet.   |
| delegation   | (Optional) A delegation block defined [Here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation)        |
| enforce_private_link_endpoint_network_policies           | (Optional) Enable or Disable network policies for the private link endpoint on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. Default value is false.   |
| enforce_private_link_service_network_policies           | (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Disable the policy and setting this to false will Enable the policy. Default value is false.   |
| service_endpoints           | (Optional) The list of Service endpoints to associate with the subnet.  |
| service_endpoint_policy_ids           | (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.   |
| tags   | (Optional) A mapping of tags to assign to the resource.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| subnet_id   | The subnet ID. |
| subnet_name   | The name of the subnet. |