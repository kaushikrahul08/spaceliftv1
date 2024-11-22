variable "company_name" {
  description = "Optional: Company name to include in the resource name"
  type        = string
  default     = null
}

variable "instance_number" {
  description = "Resource number"
  type        = string
  default     = "001"
}


variable "vnet_configurations" {
  description = "List of maps containing VNET configurations"
  type = list(object({
    subscription_type  : string
    environment        : string
    region             : string
    instance_number    : string
  }))
  default = []
}


variable "snet_configurations" {
  description = "List of maps containing SUBNET configurations"
  type = list(object({
    subscription_type  : string
    subnet_type        : string
    instance_number    : string
  }))
  default = []
}

variable "rg_configurations" {
  description = "List of maps containing VM configurations"
  type = list(object({
    #environment        : string
    subscription_type  : string
    rg_type            : string
    instance_number    : string
  }))
  default = []
}

variable "kv_configurations" {
  description = "List of maps containing VM configurations"
  type = list(object({
    subscription_type  : string
    kv_type            : string
    region             : string
    instance_number    : string
  }))
  default = []
}

variable "diag_configurations" {
  description = "List of maps containing VM configurations"
  type = list(object({
    subscription_type  : string
    rg_type            : string
    instance_number    : string
  }))
  default = []
}

variable "lga_configurations" {
  description = "List of maps containing VM configurations"
  type = list(object({
    subscription_type  : string
    lga_type            : string
    instance_number    : string
    region             : string
  }))
  default = []
}

variable "vm_configurations" {
  description = "List of maps containing VM configurations"
  type = list(object({
    vm_name           : string
    instance_number    : string
  }))
  default = []
}



locals {
  az = {
    virtual_networks = [for vnet in var.vnet_configurations : { name = format("vnet-%s-%s-%s-%s", vnet.subscription_type, vnet.environment, vnet.region, vnet.instance_number) } ]
    subnet = [for snet in var.snet_configurations : { name = format("snet-%s-%s-%s", snet.subscription_type, snet.subnet_type, snet.instance_number) } ]
    rg = [for rg in var.rg_configurations : { name = format("rg-%s-%s-%s", rg.subscription_type, rg.rg_type, rg.instance_number) } ]
    kv = [for kv in var.kv_configurations : { name = format("kv-%s-%s-%s-%s", kv.subscription_type, kv.kv_type,kv.region,kv.instance_number) } ] 
    lga = [for lga in var.lga_configurations : { name = format("lg-%s-%s-%s-%s", lga.subscription_type, lga.lga_type,lga.region,lga.instance_number) } ]
    vm = [for vm in var.vm_configurations : { name = format("vm-%s-%s", vm.vm_name,vm.instance_number) } ]
  }
}

#####Output
output "rg_name_patterns" {
  description = "Patterns for naming the Resource group"
  value       = [for rg in local.az.rg : rg.name]
}

output "vnet_name_patterns" {
  description = "Patterns for naming the Virtual Networks"
  value       = [for vnet in local.az.virtual_networks : vnet.name]
}

output "snet_name_patterns" {
  description = "Patterns for naming the Subnet"
  value       = [for snet in local.az.subnet : snet.name]
}

output "vm_name_patterns" {
  description = "Patterns for naming the Virtual Machines"
  value       = [for vm in local.az.vm : vm.name]
}


output "kv_name_patterns" {
  description = "Patterns for naming the Key vault "
  value       = [for kv in local.az.kv : kv.name]
}

output "lg_name_patterns" {
  description = "Patterns for naming the Key vault "
  value       = [for lga in local.az.lga : lga.name]
}
