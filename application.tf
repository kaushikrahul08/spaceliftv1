

#==[ DATA ]================================================================================================================================

data "azurerm_subscription" "current" {}


#==[ Resource Groups ]================================================================================================================================

# module "resource_group" {
#   source               = "./modules/resource_group"
#   for_each             = toset(module.naming.rg_name_patterns)
#   rg_name              = each.value
#   location             = local.region.azure_region              
#   tags                 = local.tags
# }


resource "azurerm_resource_group" "resource_group" {
  name     = 
  location = local.region.azure_region 
  tags     = local.tags

}
