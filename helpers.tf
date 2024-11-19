module "naming" {
  source            = "./modules/naming"
  rg_configurations = [
    {
      subscription_type = "app",
      rg_type           = "shrd"
      instance_number   = "001"
    }
  ]
  vnet_configurations = [
  {
    subscription_type = "app",
    rg_type           = "shrd"
    instance_number   = "001"
  }
]

}