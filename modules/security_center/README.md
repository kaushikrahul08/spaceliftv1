# Introduction
Security Center Environent settings enabled at subscription level. All the settings for the defender plans, notification settings and the auto provisioning settings can be enabled using this module. All settings defaulted to false.
* enable_log_analytics_auto_provision required log analytics workspace id and the log analytics solutions security and securitycenterFree need to be setup.

# Parameters
| Variable      | Description |
| :---        |    :----   |
| enable_defender_plan_for_arm      | Defender setting for arm(Defender setting for arm(true or false))       |
| enable_defender_plan_for_appServices   | Defender setting for appservices(true or false)       |
| enable_defender_plan_for_virtualmachines   | Defender setting for VM(true or false)       |
| enable_defender_plan_for_containerregistry   | Defender setting for container registry(true or false)        |
| enable_defender_plan_for_keyvault   | Defender setting for keyvault(true or false)        |
| enable_defender_plan_for_kubernetes   | Defender setting for kubernetes(true or false)     |
| enable_defender_plan_for_sqlserver      | Defender setting for sqlserver(true or false)      |
| enable_defender_plan_for_sqlservervm      | Defender setting for sqlservervm(true or false)      |
| enable_defender_plan_for_storage      | Defender setting for storage(true or false)      |
| enable_defender_plan_for_containers      | Defender setting for containers(true or false)       |
| email      | Email for security automation notificatioins      |
| phone      | Phone for security automation notificatioins       |
| alert_notifications      | alert notifications defender       |
| alerts_to_admins      | true or false       |
| enable_log_analytics_auto_provision      | Defender setting to auto provision log analytics agent       |
| subscription_id      | subscription_id       |
| enable_vulnerability_assessment_auto_provision      | Defender setting to auto provision vulunerability assessment       |
| enable_guest_configuration_agent_auto_provision      | Defender setting to auto provision guest configuration agent      |
| log_analytics_workspace_id      | LAW id       |
| identity_type      | IDentity type of the policy       |
| location      | location of the policy to be defined       |


