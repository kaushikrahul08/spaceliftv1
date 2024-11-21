locals {
  regions_defaults = {
    env_short_name = "uat"
    instance_number = "001"
  }
}

locals {
  regions_manifest = {
    euz = {
      azure_region        = "eastus"
      environments = {
        dv = {
            env_short_name = "dev"
            instance_number = "001"
        }
        tst = {
          env_short_name = "tst"
          instance_number = "002"
         }

      }

    }
    wuz = {
      azure_region        = "westus"
      environments = {
        dv = {
            env_short_name = "dev"
            instance_number = "001"
        }
        tst = {
          env_short_name = "tst"
          instance_number = "002"
         }

      }

    }

  }
}