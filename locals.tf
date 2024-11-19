locals {
    applications = {
        workload_type   = "app"
        compute_snet    = "ComputeSubnet"
        pvtlink_snet    = "PrivatelinkSubnet"
        resource_group_log_alert = ["log"]
        # kv_dns_zone_group_name   = "kvdnsgrp${var.application_name}${var.subscription_type}${var.instance_number}"
        # sa_dns_zone_group_name   = "sadnsgrp${var.application_name}${var.subscription_type}${var.instance_number}"
        # sa_pes_conn_name         = "sapeconn${var.application_name}${var.subscription_type}${var.instance_number}"
        # kv_pes_conn_name         = "kvpeconn${var.application_name}${var.subscription_type}${var.instance_number}"
        subresource_names_sa     = ["blob"]
        subresource_names_kv     = ["Vault"]
        # ops_subscription_id      = ""
        # connectivity_subscription_id = ""
  }
}

locals {
    tags = {
        ApplicationName              = "LucernexApp"
        BusinessUnit                 = "Accruent"
        Environment                  = "${var.ENVIRONMENT}"
        Owner                        = "App Department"
        CreatedOn                    = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        CreatedBy                    = "Spacelift Stack_${var.ENVIRONMENT}"
    }
}

locals {
  dv = {
    network = {
      app_vnet_address_space              = ["11.20.1.0/24"]
      app_pvtlink_subnet_address_prefixes = ["11.20.1.64/26"]
      app_cmp_subnet_address_prefixes     = ["11.20.1.0/26"]
      }
    lux_subscription_id                   = "bebb6b61-5ac1-4f45-9e8d-b64f895f94e9"

    }
}
