module "postgres" {
  source                = "../postgres"
  postgres_version      = "16"
  stack_name            = var.stack_name
  networks              = [module.network]
  placement_constraints = var.placement_constraints
  database              = "headscale"
  username              = "headscale"
  ports                 = [{ container = 5432 }]
}