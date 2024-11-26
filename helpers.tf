locals {
  region = { for x in flatten([
    for region_key, region in local.regions_manifest : [
      for environment_key, environment in region.environments : merge(local.regions_defaults, region, environment, {
        app_region                           = region_key
        app_environment                      = environment_key
        environments                         = null
        regions                              = null
      })
    ]
  ]) : "${x.app_region}_${x.app_environment}" => x }["${var.APP_REGION}_${var.APP_ENVIRONMENT}"]
}


#### Naming 
module "naming" {
  source            = "./modules/naming"
  rg_configurations = [
    {
      #environment       = "${var.APP_ENVIRONMENT}"
      subscription_type = "lux",
      rg_type           = "app01"
      instance_number   = "001"
    },
    {
      #environment       = "${var.APP_ENVIRONMENT}"
      subscription_type = "lux",
      rg_type           = "app02"
      instance_number   = "002"
    }
  ]

}