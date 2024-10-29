Introduction
Creates a simple Azure Key Vault with the following naming convention: kv-(application_name)-(subscription_type)-(instance_number)

Exp: kv-myapp-dev-001

# Parameters
| Variable      | Description |
| :---        |    :----   |
| application_name    | Application or Service name used to build the RG name |
| subscription_type | Subscription type used to build the RG name  |
| instance_number |  Instance number used to build the RG name    |
| location   | The Azure Region where the Resource Group should exist   |
| resource_group_name | (Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created |
| tags |  (Optional) A mapping of tags to assign to the resource |
| keyvault_name_override | Over ride the default genrated name |
| sku | (Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium |
| enabled_for_deployment | (Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false |
| enabled_for_disk_encryption | (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false |
| enabled_for_template_deployment | (Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false |
| enable_rbac_authorization | (Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false |
| purge_protection_enable |  (Optional) Is Purge Protection enabled for this Key Vault? Defaults to false |
| soft_delete_retention_days | (Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days |

# Outputs
| Output      | Description |
| :---        |    :----   |
| keyvault_id |  The ID of the Key Vault.
| keyvault_uri   | TThe URI of the Key Vault, used for performing operations on keys and secrets |