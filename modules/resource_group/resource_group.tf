
# Service Abbreviation
variable "location" {
  default = ""
}

variable "rg_name" {}

# Optional
variable "tags" {}

# Create a Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags

lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}


### Output

# output "resource_group_names" {
#   value = [for rg in azurerm_resource_group.resource_group : rg.name]
# }


output "rg_name_subs" {
  value = element(
    flatten([
      for rg in azurerm_resource_group.resource_group : rg.name if
      can (regex(".*(mgmt|conn|iden|log|app).*",rg.name))
    ]),
    0
  )
  
}


output "rg_name_shrd" {
  value = element(
    flatten([
      for rg in azurerm_resource_group.resource_group : rg.name if
      can (regex(".*(shrd|log).*",rg.name))
    ]),
    0
  )
  
}




# output "rg_name_sub" {
#   value = azurerm_resource_group.resource_group[0].name
# }

# output "rg_name_shrd" {
#   value = azurerm_resource_group.resource_group[1].name
  
# }

# output "rg_name_mgmt" {
#   value = element(
#     flatten([
#       for rg in azurerm_resource_group.resource_group : rg.name if
#       can (regex(".*mgmt.*",rg.name))
#     ]),
#     0
#   )
  
# }

# output "rg_name_conn" {
#   value = element(
#     flatten([
#       for rg in azurerm_resource_group.resource_group : rg.name if
#       can (regex(".*conn.*",rg.name))
#     ]),
#     0
#   )
  
# }

# output "rg_name_iden" {
#   value = element(
#     flatten([
#       for rg in azurerm_resource_group.resource_group : rg.name if
#       can (regex(".*iden.*",rg.name))
#     ]),
#     0
#   )
  
# }

