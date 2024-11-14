locals {
  ###############################################################################################################################
  # ALL STAMPS, FLATTENED
  ###############################################################################################################################
  reg_env_stamps_all = { for x in flatten([
    for region_key, region in local.regions_manifest : [
      for environment_key, environment in region.environments : [
        for stamp_key, stamp in environment.stamps : merge(local.regions_defaults, region, environment, stamp, {
          app_region      = region_key
          app_environment = environment_key
          stamp_index     = stamp_key
          environments    = null
          stamps          = null
          regions         = null
        })
      ]
    ]
  ]) : "${x.app_region}_${x.app_environment}_${x.stamp_index}" => x }

  ###############################################################################################################################
  # REGION TO BE PROVISIONED AS PART OF THE CURRENT DEPLOYMENT, FLATTENED
  ###############################################################################################################################
  region = { for x in flatten([
    for region_key, region in local.regions_manifest : [
      for environment_key, environment in region.environments : merge(local.regions_defaults, region, environment, {
        app_region                           = region_key
        app_environment                      = environment_key
        environments                         = null
        regions                              = null
        stamps                               = null
        agw_request_timeout                  = null
        agw_sku_capacity                     = null
        agw_sku_name                         = null
        agw_sku_tier                         = null
        agw_zones                            = null
        asp_os_type                          = null
        asp_zone_balancing_enabled           = null
        sqlmi_backup_delete_retention_policy = null
        sqlmi_backupstorage                  = null
        sqlmi_iszoneredundant                = null
        sqlmi_licensetype                    = null
        sqlmi_maintenance_configuration_name = null
        sqlmi_sku_name                       = null
      })
    ]
  ]) : "${x.app_region}_${x.app_environment}" => x }["${var.APP_REGION}_${var.APP_ENVIRONMENT}"]

  ###############################################################################################################################
  # ALL EMS CUSTOMERS TO BE PROVISIONED AS PART OF THE CURRENT DEPLOYMENT, FLATTENED
  ###############################################################################################################################
  all_customers = flatten([
    for customer, env in local.customers_manifest : [
      for env_k, env_v in env : customer if(env_k == var.APP_ENVIRONMENT && env_v.region == var.APP_REGION)
    ]
  ])


  ###############################################################################################################################
  # ALL EMS CUSTOMERS_STAMP TO BE PROVISIONED AS PART OF THE CURRENT DEPLOYMENT, FLATTENED
  ###############################################################################################################################
  customers_stamp = flatten([
    for customer, env in local.customers_manifest : [
      for env_k, env_v in env : "${customer}_${env_v.region}_${env_v.stamp}" if(env_k == var.APP_ENVIRONMENT && env_v.region == var.APP_REGION)
    ]
  ])

  ###############################################################################################################################
  # ALL STAMPS TO BE PROVISIONED AS PART OF THE CURRENT DEPLOYMENT
  ###############################################################################################################################
  stamps = {
    for stamp_k, stamp_v in local.reg_env_stamps_all : stamp_v.stamp_index => stamp_v if(stamp_v.app_environment == var.APP_ENVIRONMENT && stamp_v.app_region == var.APP_REGION)
  }

  ###############################################################################################################################
  # EXTRACT ENTRA ID GROUP NAME AND ID FROM JSON VARIABLE
  ###############################################################################################################################
  groups = jsondecode(var.GROUPS)

  ###############################################################################################################################
  # EXTRACT SQLMI_PR_PARTNER_ID
  ###############################################################################################################################
  sqlmi_pr_partner_id = try(jsondecode(var.SQLMI_PR_PARTNER_ID), {})

  ###############################################################################################################################
  # EXTRACT SSQLMI_DR_PARTNER_ID"
  ###############################################################################################################################
  sqlmi_dr_partner_id = try(jsondecode(var.SQLMI_DR_PARTNER_ID), {})
}
