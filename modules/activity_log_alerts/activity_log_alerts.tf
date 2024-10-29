variable "rg_name" {}
variable "subscription_id" {}
variable "location" {}
variable "tags" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }
  required_version = ">= 1.1.0"
}

locals {
  subscription = "/subscriptions/${var.subscription_id}"
}

################################################## Create Alert rule resource group ############################

resource "azurerm_resource_group" "alert_rules_rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

################################################## NSGs ########################################################

resource "azurerm_monitor_activity_log_alert" "nsg_write_activity_log_alerts" {
  name                = "nsg-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor nsg write updates."
  enabled             = false
  location            = var.location

  criteria {
    resource_type  = "Microsoft.Network/networksecuritygroups"
    operation_name = "Microsoft.Network/networkSecurityGroups/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nsg_delete_activity_log_alerts" {
  name                = "nsg-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor nsg delete updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networksecuritygroups"
    operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nsg_join_activity_log_alerts" {
  name                = "nsg-join-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor nsg join updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networksecuritygroups"
    operation_name = "Microsoft.Network/networkSecurityGroups/join/action"
    category       = "Administrative"
  }
}

# ################################################## Application Gateway ########################################################
resource "azurerm_monitor_activity_log_alert" "appgw_write_activity_log_alerts" {
  name                = "appgw-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor application gateway write updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_delete_activity_log_alerts" {
  name                = "appgw-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor application gateway delete updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_get_behealth_activity_log_alerts" {
  name                = "appgw-get-behealth-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get backend health updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/backendhealth/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_get_ondemand_behealth_activity_log_alerts" {
  name                = "appgw-get-ondemand-behealth-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get on demand backend health updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/getBackendHealthOnDemand/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_get_route_table_activity_log_alerts" {
  name                = "appgw-get-route-table-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get route table updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/effectiveRouteTable/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_get_nsg_activity_log_alerts" {
  name                = "appgw-get-nsg-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get effective Network Security Groups updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/effectiveNetworkSecurityGroups/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_get_migrationstatus_activity_log_alerts" {
  name                = "appgw-get-migrationstatus-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get migration status updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/getMigrationStatus/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_migrateV1ToV2_activity_log_alerts" {
  name                = "appgw-migrateV1ToV2-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get migration from V1 to V2 updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/migrateV1ToV2/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_resolvePrivateLinkServiceId_activity_log_alerts" {
  name                = "appgw-resolvePrivateLinkServiceId-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get Resolve Private Link Service ID updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/resolvePrivateLinkServiceId/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_restart_activity_log_alerts" {
  name                = "appgw-restart-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get restart updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/restart/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_setSecurityCenterConfiguration_activity_log_alerts" {
  name                = "appgw-setSecurityCenterConfiguration-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get Security Center Configuration updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/setSecurityCenterConfiguration/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_start_activity_log_alerts" {
  name                = "appgw-start-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get application Gateways start updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/start/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "appgw_stop_activity_log_alerts" {
  name                = "appgw-stop-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will get application Gateways stop updates."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/applicationgateways"
    operation_name = "Microsoft.Network/applicationGateways/stop/action"
    category       = "Administrative"
  }
}

################################################### Keyvaults ########################################################

resource "azurerm_monitor_activity_log_alert" "keyvault_joinPerimeter_log_alerts" {
  name                = "keyvault-joinPerimeter-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor join Perimeter actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.KeyVault/vaults"
    operation_name = "Microsoft.KeyVault/vaults/joinPerimeter/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "keyvault_PrivateEndpointConnectionsApproval_activity_log_alerts" {
  name                = "keyvault-PrivateEndpointConnectionsApproval-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Private Endpoint Connections Approval actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.KeyVault/vaults"
    operation_name = "Microsoft.KeyVault/vaults/PrivateEndpointConnectionsApproval/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "keyvault_delete_log_alerts" {
  name                = "keyvault-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.KeyVault/vaults"
    operation_name = "Microsoft.KeyVault/vaults/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "keyvault_write_activity_log_alerts" {
  name                = "keyvault-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.KeyVault/vaults"
    operation_name = "Microsoft.KeyVault/vaults/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "keyvault_deploy_activity_log_alerts" {
  name                = "keyvault-deploy-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor deploy actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.KeyVault/vaults"
    operation_name = "Microsoft.KeyVault/vaults/deploy/action"
    category       = "Administrative"
  }
}

################################################### Log Analytic workspace ########################################################

resource "azurerm_monitor_activity_log_alert" "law_write_log_alerts" {
  name                = "law-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_delete_activity_log_alerts" {
  name                = "law-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_customfields_activity_log_alerts" {
  name                = "law-customfield-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor custom field actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "microsoft.operationalinsights/workspaces/customfields/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_generateRegistrationCertificate_activity_log_alerts" {
  name                = "law-generateRegistrationCertificate-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor generateRegistrationCertificate actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/generateRegistrationCertificate/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_listKeys_activity_log_alerts" {
  name                = "law-listKeys-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listKeys actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/listKeys/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_sharedkeys_activity_log_alerts" {
  name                = "law-sharedkeys-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor sharedkeys actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/sharedkeys/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_purge_activity_log_alerts" {
  name                = "law-purge-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor purge actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/purge/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_regenerateSharedKey_log_alerts" {
  name                = "law-regenerateSharedKey-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor regenerateSharedKey actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/regenerateSharedKey/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "law_search_activity_log_alerts" {
  name                = "law-search-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor search actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.OperationalInsights/workspaces"
    operation_name = "Microsoft.OperationalInsights/workspaces/search/action"
    category       = "Administrative"
  }
}

################################################### Network interfaces ########################################################

resource "azurerm_monitor_activity_log_alert" "nic_write_log_alerts" {
  name                = "nic-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networkInterfaces"
    operation_name = "Microsoft.Network/networkInterfaces/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nic_delete_log_alerts" {
  name                = "nic-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networkInterfaces"
    operation_name = "Microsoft.Network/networkInterfaces/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nic_effectiveRouteTable_log_alerts" {
  name                = "nic-effectiveRouteTable-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitoreffectiveRouteTable actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networkInterfaces"
    operation_name = "Microsoft.Network/networkInterfaces/effectiveRouteTable/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nic_effectiveNetworkSecurityGroups_log_alerts" {
  name                = "nic-effectiveNetworkSecurityGroups-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor effectiveNetworkSecurityGroups actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networkInterfaces"
    operation_name = "Microsoft.Network/networkInterfaces/effectiveNetworkSecurityGroups/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nic_join_log_alerts" {
  name                = "nic-join-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor join actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networkInterfaces"
    operation_name = "Microsoft.Network/networkInterfaces/join/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "nic_UpdateParentNicAttachmentOnElasticNic_log_alerts" {
  name                = "nic-UpdateParentNicAttachmentOnElasticNic-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor UpdateParentNicAttachmentOnElasticNic actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/networkInterfaces"
    operation_name = "Microsoft.Network/networkInterfaces/UpdateParentNicAttachmentOnElasticNic/action"
    category       = "Administrative"
  }
}

################################################### Private Enpoints ########################################################

resource "azurerm_monitor_activity_log_alert" "pe_write_log_alerts" {
  name                = "pe-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/privateEndpoints"
    operation_name = "Microsoft.Network/privateEndpoints/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pe_delete_log_alerts" {
  name                = "pe-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/privateEndpoints"
    operation_name = "Microsoft.Network/privateEndpoints/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pe_pushPropertiesToResource_log_alerts" {
  name                = "pe-pushPropertiesToResource-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor pushPropertiesToResource actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/privateEndpoints"
    operation_name = "Microsoft.Network/privateEndpoints/pushPropertiesToResource/action"
    category       = "Administrative"
  }
}

################################################### Public IPs ########################################################

resource "azurerm_monitor_activity_log_alert" "pip_write_log_alerts" {
  name                = "pip-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/publicIPAddresses"
    operation_name = "Microsoft.Network/publicIPAddresses/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pip_delete_log_alerts" {
  name                = "pip-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/publicIPAddresses"
    operation_name = "Microsoft.Network/publicIPAddresses/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pip_ddosProtectionStatus_log_alerts" {
  name                = "pip-ddosProtectionStatus-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor ddosProtectionStatus actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/publicIPAddresses"
    operation_name = "Microsoft.Network/publicIPAddresses/ddosProtectionStatus/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pip_publicIPAddresses_log_alerts" {
  name                = "pip-publicIPAddresses-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor publicIPAddresses actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/publicIPAddresses"
    operation_name = "Microsoft.Network/publicIPAddresses/join/action"
    category       = "Administrative"
  }
}

################################################### Route Tables ########################################################

resource "azurerm_monitor_activity_log_alert" "rt_write_log_alerts" {
  name                = "rt-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/routeTables"
    operation_name = "Microsoft.Network/routeTables/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "rt_delete_log_alerts" {
  name                = "rt-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/routeTables"
    operation_name = "Microsoft.Network/routeTables/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "rt_join_log_alerts" {
  name                = "rt-join-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor join actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/routeTables"
    operation_name = "Microsoft.Network/routeTables/join/action"
    category       = "Administrative"
  }
}

################################################### Virtual Machines ########################################################

resource "azurerm_monitor_activity_log_alert" "vm_assessPatches_log_alerts" {
  name                = "vm-assessPatches-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor assessPatches actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/assessPatches/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_cancelPatchInstallation_log_alerts" {
  name                = "vm-cancelPatchInstallation-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor cancelPatchInstallation actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/cancelPatchInstallation/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_capture_log_alerts" {
  name                = "vm-capture-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor capture actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/capture/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_convertToManagedDisks_log_alerts" {
  name                = "vm-convertToManagedDisks-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor convertToManagedDisks actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/convertToManagedDisks/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_write_log_alerts" {
  name                = "vm-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_deallocate_log_alerts" {
  name                = "vm-deallocate-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor deallocate actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_delete_log_alerts" {
  name                = "vm-adelete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_generalize_log_alerts" {
  name                = "vm-generalize-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor generalize actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/generalize/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_installPatches_log_alerts" {
  name                = "vm-installPatches-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor installPatches actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/installPatches/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_powerOff_log_alerts" {
  name                = "vm-powerOff-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor powerOff actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/powerOff/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_performMaintenance_log_alerts" {
  name                = "vm-performMaintenance-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor performMaintenance actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/performMaintenance/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_reapply_log_alerts" {
  name                = "vm-reapply-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor reapply actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/reapply/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_redeploy_log_alerts" {
  name                = "vm-redeploy-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor redeploy actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/redeploy/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_reimage_log_alerts" {
  name                = "vm-reimage-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor reimage actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/reimage/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_restart_log_alerts" {
  name                = "vm-restart-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor restart actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/restart/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_retrieveBootDiagnosticsData_log_alerts" {
  name                = "vm-retrieveBootDiagnosticsData-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor retrieveBootDiagnosticsData actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/retrieveBootDiagnosticsData/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_runCommand_log_alerts" {
  name                = "vm-runCommand-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor runCommand actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/runCommand/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_simulateEviction_log_alerts" {
  name                = "vm-simulateEviction-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor simulateEviction actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/simulateEviction/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vm_start_log_alerts" {
  name                = "vm-start-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor start actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Compute/virtualMachines"
    operation_name = "Microsoft.Compute/virtualMachines/start/action"
    category       = "Administrative"
  }
}

################################################### Virtual Networks ########################################################

resource "azurerm_monitor_activity_log_alert" "vnet_write_log_alerts" {
  name                = "vnet-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_delete_log_alerts" {
  name                = "vnet-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_BastionHosts_log_alerts" {
  name                = "vnet-BastionHosts-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor BastionHosts actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/BastionHosts/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_ddosProtectionStatus_log_alerts" {
  name                = "vnet-ddosProtectionStatus-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor ddosProtectionStatus actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/ddosProtectionStatus/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_rnmEffectiveNetworkSecurityGroups_log_alerts" {
  name                = "vnet-rnmEffectiveNetworkSecurityGroups-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor rnmEffectiveNetworkSecurityGroups actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/rnmEffectiveNetworkSecurityGroups/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_rnmEffectiveRouteTable_log_alerts" {
  name                = "vnet-rnmEffectiveRouteTable-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor rnmEffectiveRouteTable actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/rnmEffectiveRouteTable/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_listDnsForwardingRulesets_log_alerts" {
  name                = "vnet-listDnsForwardingRulesets-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listDnsForwardingRulesets actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/listDnsForwardingRulesets/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_listDnsResolvers_log_alerts" {
  name                = "vnet-listDnsResolvers-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listDnsResolvers actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/listDnsResolvers/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_joinLoadBalancer_log_alerts" {
  name                = "vnet-joinLoadBalancer-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor joinLoadBalancer actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/joinLoadBalancer/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_join_log_alerts" {
  name                = "vnet-join-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor join actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/join/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_listNetworkManagerEffectiveConnectivityConfigurations_log_alerts" {
  name                = "vnet-listNetworkManagerEffectiveConnectivityConfigurations-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listNetworkManagerEffectiveConnectivityConfigurations actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/listNetworkManagerEffectiveConnectivityConfigurations/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_listNetworkManagerEffectiveSecurityAdminRules_log_alerts" {
  name                = "vnet-listNetworkManagerEffectiveSecurityAdminRules-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listNetworkManagerEffectiveSecurityAdminRules actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/listNetworkManagerEffectiveSecurityAdminRules/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vnet_peer_log_alerts" {
  name                = "vnet-peer-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor peer actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworks"
    operation_name = "Microsoft.Network/virtualNetworks/peer/action"
    category       = "Administrative"
  }
}

################################################### App Service ########################################################

resource "azurerm_monitor_activity_log_alert" "as_applySlotConfig_log_alerts" {
  name                = "as-applySlotConfig-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor applySlotConfig actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/applySlotConfig/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_PrivateEndpointConnectionsApproval_log_alerts" {
  name                = "as-PrivateEndpointConnectionsApproval-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor PrivateEndpointConnectionsApproval actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/PrivateEndpointConnectionsApproval/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_slotcopy_log_alerts" {
  name                = "as-slotcopy-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor slotcopy actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/slotcopy/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_write_log_alerts" {
  name                = "as-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/Write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_deployWorkflowArtifacts_log_alerts" {
  name                = "as-deployWorkflowArtifacts-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor deployWorkflowArtifacts actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/deployWorkflowArtifacts/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_backup_log_alerts" {
  name                = "as-backup-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor backup actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/backup/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_delete_log_alerts" {
  name                = "as-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/Delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_backups_log_alerts" {
  name                = "as-backups-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "Discovers an existing app backup."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/backups/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_functions_log_alerts" {
  name                = "as-functions-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor functions actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/functions/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_read_log_alerts" {
  name                = "as-read-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor read actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/Read"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_publishxml_log_alerts" {
  name                = "vm-publishxml-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor publishxml actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/publishxml/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_slotsdiffs_log_alerts" {
  name                = "as-slotsdiffs-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor slotsdiffs actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/slotsdiffs/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_containerlogs_log_alerts" {
  name                = "as-containerlogs-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor containerlogs actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/containerlogs/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_listworkflowsconnections_log_alerts" {
  name                = "as-listworkflowsconnections-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listworkflowsconnections actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/listworkflowsconnections/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_listbackups_log_alerts" {
  name                = "as-listbackups-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listbackups actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/listbackups/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_listsyncfunctiontriggerstatus_log_alerts" {
  name                = "as-listsyncfunctiontriggerstatus-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor listsyncfunctiontriggerstatus actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/listsyncfunctiontriggerstatus/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_migratemysql_log_alerts" {
  name                = "as-migratemysql-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor migratemysql actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/migratemysql/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_networktrace_log_alerts" {
  name                = "as-networktrace-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor networktrace actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/networktrace/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_newpassword_log_alerts" {
  name                = "as-newpassword-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor newpassword actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/newpassword/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_publish_log_alerts" {
  name                = "as-publish-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor publish actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/publish/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_recover_alerts" {
  name                = "as-recover-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor recover actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/recover/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_resetSlotConfig_log_alerts" {
  name                = "as-resetSlotConfig-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor resetSlotConfig actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/resetSlotConfig/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_restart_log_alerts" {
  name                = "as-restart-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor restart actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/restart/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_restorefrombackupblob_log_alerts" {
  name                = "as-restorefrombackupblob-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor restorefrombackupblob actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/restorefrombackupblob/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_restorefromdeletedapp_log_alerts" {
  name                = "as-restorefromdeletedapp-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor restorefromdeletedapp actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/restorefromdeletedapp/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_restoresnapshot_log_alerts" {
  name                = "as-restoresnapshot-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor restoresnapshot actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/restoresnapshot/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_start_log_alerts" {
  name                = "as-start-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor start actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/start/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_stop_log_alerts" {
  name                = "as-stop-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor stop actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/stop/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_slotsswap_log_alerts" {
  name                = "as-slotsswap-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor slotsswap actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "Microsoft.Web/sites/slotsswap/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_sync_log_alerts" {
  name                = "as-sync-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor sync actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/sync/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "as_syncfunctiontriggers_log_alerts" {
  name                = "as-syncfunctiontriggers-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor syncfunctiontriggers actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/sites"
    operation_name = "microsoft.web/sites/syncfunctiontriggers/action"
    category       = "Administrative"
  }
}

################################################### App Service plan ########################################################

resource "azurerm_monitor_activity_log_alert" "asp_Write_log_alerts" {
  name                = "asp-Write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/serverfarms"
    operation_name = "Microsoft.Web/serverfarms/Write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "asp_Delete_log_alerts" {
  name                = "asp-Delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/serverfarms"
    operation_name = "Microsoft.Web/serverfarms/Delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "asp_Read_log_alerts" {
  name                = "asp-Read-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Read actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/serverfarms"
    operation_name = "Microsoft.Web/serverfarms/Read"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "asp_Join_log_alerts" {
  name                = "asp-Join-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Join actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/serverfarms"
    operation_name = "Microsoft.Web/serverfarms/Join/Action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "asp_restartSites_log_alerts" {
  name                = "asp-restartSites-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor restartSites actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Web/serverfarms"
    operation_name = "Microsoft.Web/serverfarms/restartSites/Action"
    category       = "Administrative"
  }
}

################################################### Private DNS Zone ########################################################

resource "azurerm_monitor_activity_log_alert" "pdnsz_write_log_alerts" {
  name                = "pdnsz-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/privateDnsZones"
    operation_name = "Microsoft.Network/privateDnsZones/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pdnsz_delete_log_alerts" {
  name                = "pdnsz-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/privateDnsZones"
    operation_name = "Microsoft.Network/privateDnsZones/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "pdnsz_join_log_alerts" {
  name                = "pdnsz-join-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor join actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/privateDnsZones"
    operation_name = "Microsoft.Network/privateDnsZones/join/action"
    category       = "Administrative"
  }
}

################################################### Virtual network Gateway ########################################################

resource "azurerm_monitor_activity_log_alert" "vng_write_log_alerts" {
  name                = "vng-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor Write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "Microsoft.Network/virtualNetworkGateways/write"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_delete_log_alerts" {
  name                = "vng-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "Microsoft.Network/virtualNetworkGateways/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_generatevpnclientpackage_log_alerts" {
  name                = "vng-generatevpnclientpackage-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor generatevpnclientpackage actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/generatevpnclientpackage/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_disconnectvirtualnetworkgatewayvpnconnections_log_alerts" {
  name                = "vng-disconnectvirtualnetworkgatewayvpnconnections-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor disconnectvirtualnetworkgatewayvpnconnections actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/disconnectvirtualnetworkgatewayvpnconnections/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_generatevpnprofile_log_alerts" {
  name                = "vng-generatevpnprofile-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor generatevpnprofile actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/generatevpnprofile/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_getvpnclientconnectionhealth_log_alerts" {
  name                = "vng-getvpnclientconnectionhealth-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor getvpnclientconnectionhealth actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/getvpnclientconnectionhealth/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_getvpnclientipsecparameters_log_alerts" {
  name                = "vng-getvpnclientipsecparameters-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor getvpnclientipsecparameters actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/getvpnclientipsecparameters/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_getvpnprofilepackageurl_log_alerts" {
  name                = "vng-getvpnprofilepackageurl-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor getvpnprofilepackageurl actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/getvpnprofilepackageurl/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_getadvertisedroutes_log_alerts" {
  name                = "vng-getadvertisedroutes-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor getadvertisedroutes actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/getadvertisedroutes/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_getbgppeerstatus_log_alerts" {
  name                = "vng-getbgppeerstatus-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor getbgppeerstatus actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/getbgppeerstatus/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_supportedvpndevices_log_alerts" {
  name                = "vng-supportedvpndevices-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor supportedvpndevices actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "Microsoft.Network/virtualnetworkgateways/supportedvpndevices/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_resetvpnclientsharedkey_log_alerts" {
  name                = "vng-resetvpnclientsharedkey-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor resetvpnclientsharedkey actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/resetvpnclientsharedkey/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_reset_log_alerts" {
  name                = "vng-reset-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor reset actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/reset/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_setvpnclientipsecparameters_log_alerts" {
  name                = "vng-setvpnclientipsecparameters-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor setvpnclientipsecparameters actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/setvpnclientipsecparameters/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_startpacketcapture_log_alerts" {
  name                = "vng-startpacketcapture-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor startpacketcapture actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/startpacketcapture/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "vng_stoppacketcapture_log_alerts" {
  name                = "vng-stoppacketcapture-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor stoppacketcapture actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Network/virtualNetworkGateways"
    operation_name = "microsoft.network/virtualnetworkgateways/stoppacketcapture/action"
    category       = "Administrative"
  }
}

################################################### Front Door ########################################################

resource "azurerm_monitor_activity_log_alert" "fd_CheckHostNameAvailability_log_alerts" {
  name                = "fd-CheckHostNameAvailability-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor CheckHostNameAvailability actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/CheckHostNameAvailability/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_CheckResourceUsage_log_alerts" {
  name                = "fd-CheckResourceUsage-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor CheckResourceUsage actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/CheckResourceUsage/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_delete_log_alerts" {
  name                = "fd-delete-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor delete actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/delete"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_GenerateSsoUri_log_alerts" {
  name                = "fd-GenerateSsoUri-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor GenerateSsoUri actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/GenerateSsoUri/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_GetSupportedOptimizationTypes_log_alerts" {
  name                = "fd-GetSupportedOptimizationTypes-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor GetSupportedOptimizationTypes actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/GetSupportedOptimizationTypes/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_upgrade_log_alerts" {
  name                = "fd-upgrade-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor upgrade actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/Upgrade/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_usages_log_alerts" {
  name                = "fd-usages-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor usages actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/Usages/action"
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "fd_write_log_alerts" {
  name                = "fd-write-activitylogalert"
  resource_group_name = var.rg_name
  scopes              = [local.subscription]
  description         = "This alert will monitor write actions."
  enabled             = false

  criteria {
    resource_type  = "Microsoft.Cdn/profiles"
    operation_name = "Microsoft.Cdn/profiles/write"
    category       = "Administrative"
  }
}