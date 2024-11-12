
variable "log_analytics_workspace_resource_group_name" {}
variable "log_analytics_workspace_id" {}
variable "identity_type" {}
variable "location" {}
variable "email" {}
variable "phone" {}
variable "client_id" {}
variable "client_secret" {}

variable "enable_asb_assignment" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_arm" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_appServices" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_virtualmachines" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_containerregistry" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_keyvault" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_kubernetes" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_sqlserver" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_sqlservervm" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_storage" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_dns" {
  type    = bool
  default = false
}
variable "enable_defender_plan_for_containers" {
  type    = bool
  default = false
}
variable "enable_defender_for_containers_auto_provision" {
  type    = bool
  default = false
}

variable "enable_vulnerability_assessment_auto_provision" {
  type    = bool
  default = false
}
variable "enable_guest_configuration_agent_auto_provision" {
  type    = bool
  default = false
}

variable "alerts_to_admins" {
  default = false
}

variable "alert_notifications" {
  default = true
}

variable "enable_log_analytics_auto_provision" {
  type    = bool
  default = true
}

variable "enable_diagnostic_settings" {
  type    = bool
  default = true
}

# Get current client configuration from azurerm provider
data "azurerm_subscription" "current" {}

# Locals
locals {
  cl_id   = var.client_id
  # az_info builds a csv string of: "<client_id>,<client_secret>,<current_tenant_id>,<current_subscription_id>"
  az_info = "${var.client_id},${var.client_secret},${chomp(data.azurerm_subscription.current.tenant_id)},${chomp(substr(data.azurerm_subscription.current.id, 15, length(data.azurerm_subscription.current.id)))}"
}

# Enabling the default Azure Security Benchmark Policy initiative
resource "azurerm_subscription_policy_assignment" "asb_assignment" {
  count                = var.enable_asb_assignment ? 1 : 0
  name                 = "azuresecuritybenchmark"
  display_name         = "Azure Security Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  subscription_id      = data.azurerm_subscription.current.id
}

# Enable the workload protection defender plans
resource "azurerm_security_center_subscription_pricing" "mdc_arm" {
  count         = var.enable_defender_plan_for_arm ? 1 : 0
  tier          = "Free"
  resource_type = "Arm"
}


resource "azurerm_security_center_subscription_pricing" "mdc_appservices" {
  count         = var.enable_defender_plan_for_appServices ? 1 : 0
  tier          = "Free"
  resource_type = "AppServices"
}


resource "azurerm_security_center_subscription_pricing" "mdc_vm" {
  count         = var.enable_defender_plan_for_virtualmachines ? 1 : 0
  tier          = "Free"
  resource_type = "VirtualMachines"
}


resource "azurerm_security_center_subscription_pricing" "mdc_containerregistry" {
  count         = var.enable_defender_plan_for_containerregistry ? 1 : 0
  tier          = "Free"
  resource_type = "ContainerRegistry"
}


resource "azurerm_security_center_subscription_pricing" "mdc_keyVaults" {
  count         = var.enable_defender_plan_for_keyvault ? 1 : 0
  tier          = "Free"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_subscription_pricing" "mdc_kubernetes" {
  count         = var.enable_defender_plan_for_kubernetes ? 1 : 0
  tier          = "Free"
  resource_type = "KubernetesService"
}


resource "azurerm_security_center_subscription_pricing" "mdc_sqlservers" {
  count         = var.enable_defender_plan_for_sqlserver ? 1 : 0
  tier          = "Free"
  resource_type = "SqlServers"
}


resource "azurerm_security_center_subscription_pricing" "mdc_sqlvmservers" {
  count         = var.enable_defender_plan_for_sqlservervm ? 1 : 0
  tier          = "Free"
  resource_type = "SqlServerVirtualMachines"
}



resource "azurerm_security_center_subscription_pricing" "mdc_storage" {
  count         = var.enable_defender_plan_for_storage ? 1 : 0
  tier          = "Free"
  resource_type = "StorageAccounts"
}


resource "azurerm_security_center_subscription_pricing" "mdc_dns" {
  count         = var.enable_defender_plan_for_dns ? 1 : 0
  tier          = "Free"
  resource_type = "Dns"
}


resource "azurerm_security_center_subscription_pricing" "mdc_containers" {
  count         = var.enable_defender_plan_for_containers ? 1 : 0
  tier          = "Free"
  resource_type = "Containers"
}



# Setup the security contacts
resource "azurerm_security_center_contact" "mdc_contact" {
  name                = "occ-contact"
  email               = var.email
  phone               = var.phone
  alert_notifications = var.alert_notifications
  alerts_to_admins    = var.alerts_to_admins
}

# Enable Log Analytics agent auto-provisioning
# resource "azurerm_security_center_auto_provisioning" "auto-provisioning" {
#   count          = var.enable_log_analytics_auto_provision ? 1 : 0
#   auto_provision = "On"
# }


# Vulnerability_assessment is enabled through a policy
resource "azurerm_subscription_policy_assignment" "va-auto-provisioning" {
  count                = var.enable_vulnerability_assessment_auto_provision ? 1 : 0
  name                 = "mdc-va-autoprovisioning"
  display_name         = "Configure machines to receive a vulnerability assessment provider"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/13ce0167-8ca6-4048-8e6b-f996402e3c1b"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = var.identity_type
  }
  location   = var.location
  parameters = <<PARAMS
{ "vaType": { "value": "mdeTvm" } }
PARAMS
}

# Configure Continuous Export settings
resource "azurerm_security_center_automation" "la-exports" {
 count                = var.enable_vulnerability_assessment_auto_provision ? 1 : 0
  name                = "ExportToWorkspace"
  location            =  var.location == "eastus2" ? "westus2" : var.location # NOTE: West US 3 does not have the Security Automations provider, so use West US 2 instead.
  resource_group_name = var.log_analytics_workspace_resource_group_name

  action {
    type        = "loganalytics" # NOTE: This is intentionally lowercase. CamelCase causes an error.
    resource_id = var.log_analytics_workspace_id
  }

  source {
    event_source = "Alerts"
    rule_set {
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "High"
        property_type  = "String"
      }
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "Medium"
        property_type  = "String"
      }
    }
  }

  source {
    event_source = "SecureScores"
  }

  source {
    event_source = "SecureScoreControls"
  }

  source {
    event_source = "Assessments"
    rule_set {
      rule {
        property_path  = "properties.metadata.severity"
        operator       = "Equals"
        expected_value = "High"
        property_type  = "String"
      }
      rule {
        property_path  = "properties.metadata.severity"
        operator       = "Equals"
        expected_value = "Medium"
        property_type  = "String"
      }
      rule {
        property_path  = "properties.metadata.severity"
        operator       = "Equals"
        expected_value = "Low"
        property_type  = "String"
      }
    }
  }

  scopes = [data.azurerm_subscription.current.id]
}

resource "azurerm_role_assignment" "va-auto-provisioning-identity-role" {
  count              = var.enable_vulnerability_assessment_auto_provision ? 1 : 0
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.va-auto-provisioning[0].identity[0].principal_id
}

# Microsoft Defender for containers is enabled through a policy
resource "azurerm_subscription_policy_assignment" "mdc-auto-provisioning" {
  count                = var.enable_defender_for_containers_auto_provision ? 1 : 0
  name                 = "mdc-auto-provisioning"
  display_name         = "Defender for Containers provisioning Azure Policy Addon for Kubernetes"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/64def556-fbad-4622-930e-72d1d5589bf5"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = var.identity_type
  }
  location   = var.location
  parameters = <<PARAMS
{ "effect": { "value": "DeployIfNotExists" } }
PARAMS
}

resource "azurerm_role_assignment" "mdc-auto-provisioning-identity-role" {
  count              = var.enable_defender_for_containers_auto_provision ? 1 : 0
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.mdc-auto-provisioning[0].identity[0].principal_id
}



#Guest Configuration Agent is enabled through a policy
#Deploy the Linux Guest Configuration extension to enable Guest Configuration assignments on Linux VMs
resource "azurerm_subscription_policy_assignment" "guest-configuration-auto-provisioning_linux" {
  count                = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  name                 = "mdc-gca-autoprovisioning-linux"
  display_name         = "Configure machines to enable guest configuration agent"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/331e8ea8-378a-410f-a2e5-ae22f38bb0da"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = var.identity_type
  }
  location = var.location
}

resource "azurerm_role_assignment" "gca-auto-provisioning-identity-role_linux" {
  count              = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.guest-configuration-auto-provisioning_linux[0].identity[0].principal_id
}

#Deploy the Windows Guest Configuration extension to enable Guest Configuration assignments on Windows VMs
resource "azurerm_subscription_policy_assignment" "guest-configuration-auto-provisioning_win" {
  count                = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  name                 = "mdc-gca-autoprovisioning-windows"
  display_name         = "Configure machines to enable guest configuration agent"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/385f5831-96d4-41db-9a3c-cd3af78aaae6"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = var.identity_type
  }
  location = var.location
}

resource "azurerm_role_assignment" "gca-auto-provisioning-identity-role_win" {
  count              = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.guest-configuration-auto-provisioning_win[0].identity[0].principal_id
}

#Add system-assigned managed identity to enable Guest Configuration assignments on virtual machines with no identities
resource "azurerm_subscription_policy_assignment" "guest-configuration-auto-provisioning_identity" {
  count                = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  name                 = "mdc-gca-autoprovisioning-no-identity"
  display_name         = "Configure machines to enable guest configuration agent"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3cf2ab00-13f1-4d0c-8971-2ac904541a7e"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = var.identity_type
  }
  location = var.location
}

resource "azurerm_role_assignment" "gca-auto-provisioning-identity-role_identity" {
  count              = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.guest-configuration-auto-provisioning_identity[0].identity[0].principal_id
}

#Add system-assigned managed identity to enable Guest Configuration assignments on VMs with a user-assigned identity
resource "azurerm_subscription_policy_assignment" "guest-configuration-auto-provisioning_user" {
  count                = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  name                 = "mdc-gca-autoprovisioning-user-assigned-identity"
  display_name         = "Configure machines to enable guest configuration agent"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/497dff13-db2a-4c0f-8603-28fa3b331ab6"
  subscription_id      = data.azurerm_subscription.current.id
  identity {
    type = var.identity_type
  }
  location = var.location
}

resource "azurerm_role_assignment" "gca-auto-provisioning-identity-role_user" {
  count              = var.enable_guest_configuration_agent_auto_provision ? 1 : 0
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_subscription_policy_assignment.guest-configuration-auto-provisioning_user[0].identity[0].principal_id
}

# Generate Random IDs for use in a unique name
resource "random_id" "mds_id" {
  keepers = {
    # Generate a new id each time we switch to a new resource group
    group_name = var.log_analytics_workspace_resource_group_name
  }
  byte_length = 1 # NOTE: A hex string will be twice as long as the byte_length
}
