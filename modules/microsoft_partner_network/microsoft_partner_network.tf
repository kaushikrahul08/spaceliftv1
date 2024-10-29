# Variables
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

# Required Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }
  required_version = ">= 1.1.0"
}

# Locals
locals {
  az_info = "${var.client_id},${var.client_secret},${var.tenant_id}"
}

# Set Microsoft Partner Network (MPN) ID for Cloud Foundations Requirements
# NOTE: '4440420' is the MPN ID for TEKsystems Global Services, LLC.
resource "null_resource" "set_mpn" {
  triggers = {
    ad_info = local.az_info
  }
  provisioner "local-exec" {
    command = <<-EOD
      az extension add --name managementpartner
      az login --service-principal -u ${element(split(",", self.triggers.ad_info), 0)} -p ${element(split(",", self.triggers.ad_info), 1)} --tenant ${element(split(",", self.triggers.ad_info), 2)}
      az managementpartner create --partner-id 4440420
      az logout
    EOD
    on_failure = continue
  }
}
