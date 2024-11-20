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
  ]) : "${x.app_region}_${x.app_environment}" => x }["${var.LOCATION}_${var.ENVIRONMENT}"]
}





module "naming" {
  source            = "./modules/naming"
  rg_configurations = [
    {
      environment       = "${var.ENVIRONMENT}"
      subscription_type = "lux",
      rg_type           = "shrd"
      instance_number   = "001"
    }
  ]

}