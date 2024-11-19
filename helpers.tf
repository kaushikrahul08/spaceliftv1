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
