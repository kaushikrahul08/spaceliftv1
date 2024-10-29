# Introduction 
Creates a Log Analytics Workspace with the following naming convention: k8s-workspace-(random id in hex)

Exp: k8s-workspace-###

# Parameters
| Variable      | Description |
| :---        |    :----   |
| name_prefix | Used to build the name of the workspace |
| location   | The Azure Region where the Resource Group should exist.        |
| resource_group_name           | Specifies the Resource Group where the Log Analytics Workspace should exist.   |
| name_override           | (Optional) When provided, this variable overrides the resource naming convention in the module and assings the provided name.   |
| sku   | (Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| id   | The Log Analytics Workspace ID. |
| workspace_id   | The Workspace (or Customer) ID for the Log Analytics Workspace. |
| workspace_mame   | The full name of the Log Analytics workspace with which the solution will be linked. Changing this forces a new resource to be created. |