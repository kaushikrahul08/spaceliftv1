locals {
  regions_defaults = {
    env_short_name = "uat"
  }
}

locals {
  regions_manifest = {
    euz = {
      azure_region        = "eastus"
      environment = {
        dv = {
            env_short_name = "dev"
            instance_number = "001"
        }
        ts = {
          env_short_name = "tst"
          instance_number = "002"
         }

      }

    }
    wuz = {
      azure_region        = "westus"
      environment = {
        dv = {
            env_short_name = "dev"
            instance_number = "001"
        }
        ts = {
          env_short_name = "tst"
          instance_number = "002"
         }

      }

    }

  }
}