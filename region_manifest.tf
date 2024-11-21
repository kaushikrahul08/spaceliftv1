locals {
  regions_defaults = {
    instance_number = "001"
  }
}

locals {
  regions_manifest = {
    euz = {
      azure_region        = "eastus"
      environments = {
        dv = {
          instance_number = "005"
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