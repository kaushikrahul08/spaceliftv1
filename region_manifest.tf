locals {
  regions_defaults = {
    instance_number = "001"
  }
}

locals {
  regions_manifest = {
    euz = {
      azure_region        = "westus"
      enable_rg           = true
      environments = {
        dv = {
          environment     = "${var.APP_ENVIRONMENT}"
        }
        tst = {
          environment     = "${var.APP_ENVIRONMENT}"
         }
        prod = {
          environment     = "${var.APP_ENVIRONMENT}"
         }


      }

    }
    wuz = {
      azure_region        = "westus"
      enable_rg           = true

      environments = {
        dv = {
          environment     = "${var.APP_ENVIRONMENT}"
        }
        tst = {
          environment     = "${var.APP_ENVIRONMENT}"
         }
        prod = {
          environment     = "${var.APP_ENVIRONMENT}"
         }


      }

    }

  }
}
