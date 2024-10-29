# Introduction 
Creates a simple Azure resource group with the following naming convention: rg-(application_name)-(subscription_type)-(instance_number)

Exp: rg-myapp-dev-001

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name      | Application or Service name used to build the RG name       |
| subscription_type   | Subscription type used to build the RG name        |
| instance_number   | Instance number used to build the RG name        |
| location   | The Azure Region where the Resource Group should exist.        |
| provider   | (Optional) Defines a provider alias used to point to a specific subscription.        |
| tags   | (Optional) A mapping of tags to assign to the resource.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| resource_group_name   | Name of the created resource group |
| rg_location   | Location of the created resource group |