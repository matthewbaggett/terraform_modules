module "frontend" {
  source                = "../../docker/service"
  depends_on            = [module.postgres]
  enable                = var.enable
  placement_constraints = var.placement_constraints.default
  stack_name            = var.stack_name
  service_name          = "frontend"
  image                 = "hoppscotch/hoppscotch-frontend"
  environment_variables = local.environment
  parallelism_per_node  = 1
  start_first           = false
  traefik               = { domain = var.domains.frontend, ssl = true, non-ssl = true, port = 80 }
  networks              = concat([module.network], var.networks)
  converge_enable       = false
  healthcheck           = ["CMD", "/bin/true"] // @todo MB: fix this
  ports = [
    { container = 80, host = 3080, publish_mode = var.publish_mode },
    { container = 3000, host = 3000, publish_mode = var.publish_mode },
    { container = 3200, host = 3200, publish_mode = var.publish_mode },
  ]
}