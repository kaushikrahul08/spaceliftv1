
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.110.0"
#     }
#   }
#   required_version = ">= 1.1.0"
# }

variable "abbreviation" {
  default = "bkpol"
}

variable "bkp_target" {}
variable "orgid" {
  default = ""
}
variable "workload" {
  default = ""
}
variable "environment" {
  default = ""
}
variable "location" {
  default = ""
}

variable "location_short_name" {
  default = ""
}

variable "instance_number" {
  default = ""
}

# Overrides
variable "name_override" {
  default = ""
}

# Required
variable "resource_group_name" {}


# Optional
variable "tags" {}

###############################
# Azure Backup flags
###############################

variable "backup_vm_enabled" {
  description = "Whether the Virtual Machines backup is enabled."
  type        = bool
  default     = false
}

variable "backup_file_share_enabled" {
  description = "Whether the File Share backup is enabled."
  type        = bool
  default     = false
}

variable "backup_postgresql_enabled" {
  description = "Whether the PostgreSQL backup is enabled."
  type        = bool
  default     = true
}

variable "backup_storage_blob_enabled" {
  description = "Whether the Storage blob backup is enabled."
  type        = bool
  default     = true
}

variable "backup_managed_disk_enabled" {
  description = "Whether the Managed Disk backup is enabled."
  type        = bool
  default     = false
}

variable "backup_vault_datastore_type" {
  description = "Type of data store used for the Backup Vault."
  type        = string
  default     = "VaultStore"
}

variable "backup_vault_geo_redundancy_enabled" {
  description = "Whether the geo redundancy is enabled no the Backup Vault."
  type        = bool
  default     = true
}

variable "backup_vault_identity_type" {
  description = "Azure Backup Vault identity type. Possible values include: `null`, `SystemAssigned`. Default to `SystemAssigned`."
  type        = string
  default     = "SystemAssigned"
}


variable "frequency_daily" {}
variable "frequency_weekly" {}
variable "frequency_monthly" {}
variable "Occurs" {}
variable "time" {}
variable "timezone" {}
variable "retention_daily" {}
variable "retention_weekly" {}
variable "retention_monthly" {}
variable "week_day" {}
variable "protection_target" {}

##########Backup Vault - supports datasources type Azure PostgreSQL ,Azure Blobs, Azure Disk,AKS,Postgres flexible
resource "azurerm_data_protection_backup_vault" "vault" {
  name                = "${var.abbreviation}${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  resource_group_name = var.resource_group_name
  location            = var.location
  datastore_type      = var.backup_vault_datastore_type
  redundancy          = var.backup_vault_geo_redundancy_enabled ? "GeoRedundant" : "LocallyRedundant"

  dynamic "identity" {
    for_each = toset(var.backup_vault_identity_type != null ? ["_"] : [])
    content {
      type = var.backup_vault_identity_type
    }
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }

}

resource "azurerm_data_protection_backup_policy_blob_storage" "blob_policy_daily" {
  name     = "${var.abbreviation}-${var.protection_target}-${lower(var.frequency_daily)}-${var.Occurs}-${var.retention_daily}d-${var.environment}"
  vault_id = azurerm_data_protection_backup_vault.vault.id
  operational_default_retention_duration = "P${var.retention_daily}D"
  
}


resource "azurerm_data_protection_backup_policy_blob_storage" "blob_policy_weekly" {

  name     = "${var.abbreviation}-${var.protection_target}-${lower(var.frequency_weekly)}-${var.Occurs}-${var.retention_weekly}w-${var.environment}"
  vault_id = azurerm_data_protection_backup_vault.vault.id
  operational_default_retention_duration = "P${var.retention_daily}W"

}

resource "azurerm_data_protection_backup_policy_blob_storage" "blob_policy_monthly" {

  name     = "${var.abbreviation}-${var.protection_target}-${lower(var.frequency_monthly)}-${var.Occurs}-${var.retention_monthly}m-${var.environment}"
  vault_id = azurerm_data_protection_backup_vault.vault.id
  operational_default_retention_duration = "P${var.retention_daily}M"

}


##########Recovery Service Vault - supports datasources type Azure VMs, Backup agent,Backup server,DPM,Azure Files, SQL in Azure VM, SAP HANA

resource "azurerm_recovery_services_vault" "rsv" {
  name                          = "rsv${var.orgid}${var.workload}${var.environment}${var.location_short_name}${var.instance_number}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Standard"
  tags                          = var.tags
  soft_delete_enabled           = "true"
  storage_mode_type             = var.backup_vault_geo_redundancy_enabled ? "GeoRedundant" : "LocallyRedundant"
  lifecycle {
      ignore_changes = [
        tags["CreatedOn"]
      ]
    }

  dynamic "identity" {
    for_each = toset(var.backup_vault_identity_type != null ? ["_"] : [])
    content {
      type = var.backup_vault_identity_type
    }

}
}
#bkpol-<Backup-target>-<Frequency>-<Occurs>-<Retain For>-<env>-<region>
resource "azurerm_backup_policy_vm" "vm_daily" {
  name                          = "${var.abbreviation}-${var.bkp_target}-${lower(var.frequency_daily)}-${var.Occurs}-${var.retention_daily}d-${var.environment}"
  resource_group_name            = var.resource_group_name
  recovery_vault_name            = azurerm_recovery_services_vault.rsv.name
  instant_restore_retention_days = 2
  timezone                       = var.timezone
  policy_type                    = "V1"
  
  backup {
    frequency = var.frequency_daily
    time      = var.time #HH:MM
  }
  
  retention_daily {
    count = var.retention_daily
  }

}

resource "azurerm_backup_policy_vm" "vm_weekly" {
  name                          = "${var.abbreviation}-${var.bkp_target}-${lower(var.frequency_weekly)}-${var.Occurs}-${var.retention_weekly}w-${var.environment}"
  resource_group_name            = var.resource_group_name
  recovery_vault_name            = azurerm_recovery_services_vault.rsv.name
  instant_restore_retention_days = 5
  timezone                       = var.timezone
  policy_type                    = "V1"
  backup {
    frequency = var.frequency_weekly
    time      = var.time
    weekdays  = [var.week_day]
  }
  
   retention_weekly {
    count    = var.retention_weekly
    weekdays = [var.week_day]
  }

   retention_monthly {
    count    = var.retention_monthly
    weekdays = [var.week_day]
    weeks    = ["Second"]
  }

  lifecycle {
    ignore_changes = [retention_monthly
    ["count"]
    ]
  }


}

#Output:

output "rsv_id" {
  value = azurerm_recovery_services_vault.rsv.id
}
output "bkpvault_name" {
  value = azurerm_data_protection_backup_vault.vault.name
}

output "bkpvault_id" {
  value = azurerm_data_protection_backup_vault.vault.id
}