# Introduction 
Creates a network_security_group with the following naming convention: nsg-(application_name)-(subscription_type)-(instance_number)

Exp: nsg-myapp-dev-1

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name      | Application or Service name used to build the virtual network name       |
| subscription_type   | Subscription type used to build the RG name        |
| resource_group_name           | The name of the resource group in which to create the virtual network.   |
| instance_number   | Instance number used to build the NSG name        |
| location   | The Azure Region where the Resource Group should exist.        |
| name_override   | (Optional) Explicitly override the module generated name.        |

| tags   | (Optional) A mapping of tags to assign to the resource.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| network_security_group_id   | The ID of the network security group |
| network_security_group_name   | The name of the network security group |