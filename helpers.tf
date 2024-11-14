
################################################################################
## HELPERS
################################################################################
locals {

  github_variables = tomap({
    for y in flatten([
      for x in data.github_actions_variables.current.variables : {
        name       = x.name
        created_at = x.created_at
        updated_at = x.updated_at
        value      = x.value
      }
    ]) : y.name => y
  })

  app_envs = { for x in flatten([
    for app_key, app in local.applications : [
      for env_key, env in app.environments : merge(local.defaults.applications, app, env, {
        app             = app_key
        env             = env_key
        environments    = null
        name            = null
        subscriptions   = null
        app_name        = app.name
        mg_name         = "${app_key}-${local.environments[env_key].name}"
        mg_display_name = local.environments[env_key].name
      })
    ]
  ]) : "${x.app}-${x.env}" => x }

  app_env_subs = { for x in flatten([
    for app_key, app in local.applications : [
      for env_key, env in app.environments : [
        for sub_key, sub in env.subscriptions : merge(local.defaults.applications, app, env, local.flat_regions[sub.region], sub, {
          app                 = app_key
          env                 = env_key
          sub                 = sub_key
          environments        = null
          name                = null
          subscriptions       = null
          subscription_name   = try(sub.subscription_name, "${app_key}-${env_key}-${sub_key}")
          vwan_peering_name   = "${local.flat_regions[sub.region].vwan_hub_name}-to-${app_key}-${env_key}-${sub_key}"
          github_environment  = try(sub.github_environment, "${app_key}-${env_key}-${sub_key}")
          mg_key              = "${app_key}-${env_key}"
          app_reg_name_admin  = try(sub.app_reg_name_admin, "inf-${app_key}-${env_key}-${sub_key}-admin")
          app_reg_name_deploy = try(sub.app_reg_name_deploy, "inf-${app_key}-${env_key}-${sub_key}-deploy")
        })
      ]
    ]
  ]) : "${x.app}-${x.env}-${x.sub}" => x }

  flat_regions = { for x in flatten([
    for geok, geo in local.geographies : [
      for regionk, region in geo.regions : merge(region, {
        geography_name = geo.name
        geography_key  = geok
        region         = regionk
      })
    ]
  ]) : x.region => x }

  app_dns_zones = { for x in flatten([
    for appk, appv in local.applications : [
      for zonek, zonev in try(appv.dns_zones, {}) : {
        key            = "${appk}_${zonek}"
        repo_name      = appv.repo_name
        variable_name  = upper("TF_VAR_DNS_ZONE_${zonek}")
        variable_value = zonev
        pipeline       = appv.pipeline
      }
    ]
  ]) : x.key => x }

  app_repo_variables = { for x in flatten([
    for appk, appv in local.applications : [
      for vark, varv in try(appv.repo_github_variables, {}) : {
        key            = "${appk}_${vark}"
        repo_name      = appv.repo_name
        variable_name  = upper(vark)
        variable_value = varv
        pipeline       = appv.pipeline
      }
    ]
  ]) : x.key => x }

}
