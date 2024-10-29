# Introduction 
Allows to enable diagnostic logs to individual resource or a subscription.

# Parameters
| Variable      | Description |
| :---        |    :----   |
| enable_kv_logs_to_log_analytics | bool- Enable diagnostic setting for kv|
| enable_kv_logs_to_storage        | bool - Enable kv logs to storage|
| enable_aks_logs_to_log_analytics | bool- Enable diagnostic setting for kv |
| enable_aks_logs_to_storage |bool - Enable kv logs to storage |
| enable_appgw_logs_to_log_analytics   | bool- Enable diagnostic setting for kv |
| enable_appgw_logs_to_storage | bool - Enable kv logs to storage |
| enable_appservice_logs_to_log_analytics | bool- Enable diagnostic setting for kv |
| enable_postgresql_logs_to_storage   | bool - Enable kv logs to storage |
| kv_logs   | list of kv logs to be enabled |
| kv_metrics   | list of kv metrics |
| enable_automation_logs_to_log_analytics   | (Optional) A mapping of tags to assign to the resource. |
| automation_logs   | list of log categories|
| automation_metrics   | list of metric categories |
| automation_account_id   | automation account id to enable activity logs diagnostic settings |
| appservice_logs   | list of log categories |
| appservice_metrics   | list of metric categories |
| key_vault_id   | Key vault id to enable activity logs diagnostic settings|
| diagnostics_storage_account_name   | diagnostic storage account name for logs diagnostic settings |
| log_analytics_workspace_id   | Log analytic workspace id for logs |
| aks_cluster_id   | aks cluster id to enable activity logs diagnostic settings |
| app_service_id   | app service id to enable activity logs diagnostic settings |
| app_gateway_id   | app gateway id to enable activity logs diagnostic settings |
| appservice_logs   | app service log categories |
| subscription_logs   | subscription log categories |
| enable_subscription_activity_setting   | bool - enable activiy diagnostic log on the subscription| . |
| subscription_id   | Subscirption id to enable activity logs diagnostic settings |

# Usefull info
link to diagnostic log categories: https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-schema#service-specific-schemas