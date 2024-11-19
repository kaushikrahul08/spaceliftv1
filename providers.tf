################################################################################
## REQUIRED PROVIDERS
################################################################################

terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.102.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.16.1"
    }
  }
}

################################################################################
## AZURERM
################################################################################

provider "azurerm" {
  features {}
}

################################################################################
## AZURE AD
################################################################################

provider "azuread" {

}

################################################################################
## GITHUB
################################################################################


################################################################################
## PROVIDER: SPACELIFT
################################################################################

provider "spacelift" {
}
