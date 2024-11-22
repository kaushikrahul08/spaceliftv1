

#==[ DATA ]================================================================================================================================

data "azurerm_subscription" "current" {}


#==[ Resource Groups ]================================================================================================================================

module "resource_group" {
  for_each = local.region.enable_rg == true ? toset(module.naming.rg_name_patterns) : toset([])

  source   = "./modules/resource_group"
  rg_name  = "${each.value}-${local.prefix}"
  location = local.region.azure_region
  tags     = local.tags
}