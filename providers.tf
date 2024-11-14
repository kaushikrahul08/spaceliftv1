terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.114"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.39.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.9"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
  }
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
provider "azurerm" {
  subscription_id = local.ops_subscription_id
  alias           = "ops"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
provider "azurerm" {
  subscription_id = local.connectivity_subscription_id
  alias           = "connectivity"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}


## RPS set to 3 to reduce rateLimtiing (Default 4)
provider "cloudflare" {
  rps = 3
}

