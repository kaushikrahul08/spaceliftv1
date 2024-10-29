# Introduction 
Creates a complete deployment of all the components in the Azure Landing Zone Management subscription

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name      | Application or Service name used to build the RG name       |
| subscription_type   | Subscription type used to build the RG name        |
| instance_number   | Instance number used to build the RG name        |
| location   | The Azure Region where the Resource Group should exist.        |
| identity_vnet_address_space   | The address space that is used by the virtual network. You can supply more than one address space.         |
| tags   | (Optional) A mapping of tags to assign to the resource.        |
