module "admin" {
  source                = "../../docker/service"
  depends_on            = [module.postgres]
  enable                = var.enable
  placement_constraints = var.placement_constraints.default
  stack_name            = var.stack_name
  service_name          = "admin"
  image                 = "hoppscotch/hoppscotch-admin"
  environment_variables = local.environment
  parallelism_per_node  = 1
  start_first           = false
  traefik               = { domain = var.domains.admin, ssl = true, non-ssl = true, port = 80 }
  networks              = concat([module.network], var.networks)
  converge_enable       = false
  healthcheck           = ["CMD", "/bin/true"] // @todo MB: fix this
  ports = [
    { container = 80, host = 3280, publish_mode = var.publish_mode },
    { container = 3100, host = 3100, publish_mode = var.publish_mode },
  ]
}