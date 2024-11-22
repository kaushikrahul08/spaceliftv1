locals {
  regions_defaults = {
    instance_number = "001"
  }
}

locals {
  regions_manifest = {
    euz = {
      azure_region        = "eastus"
      enable_rg           = false
      environments = {
        dv = {
          environment     = "${var.APP_ENVIRONMENT}"
        }
        tst = {
          instance_number = "002"
         }

      }

    }
    wuz = {
      azure_region        = "westus"
      environments = {
        dv = {
          instance_number = "001"
        }
        tst = {
          instance_number = "002"
         }

      }

    }

  }
}