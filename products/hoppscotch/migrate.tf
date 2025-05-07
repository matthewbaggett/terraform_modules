module "migrate" {
  source                = "../../docker/service"
  depends_on            = [module.postgres]
  enable                = var.enable
  placement_constraints = var.placement_constraints.default
  stack_name            = var.stack_name
  service_name          = "migrate"
  image                 = "hoppscotch/hoppscotch"
  environment_variables = local.environment
  parallelism_per_node  = 1
  networks              = [module.network]
  converge_enable       = false
  one_shot              = true
  healthcheck           = ["CMD", "/bin/true"] // @todo MB: fix this
  command               = ["sh", "-c", "pnpx prisma migrate deploy"]
}
