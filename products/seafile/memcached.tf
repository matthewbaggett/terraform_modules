module "memcached" {
  source                = "../memcached"
  enable                = var.enable
  stack_name            = var.stack_name
  networks              = [module.network]
  placement_constraints = var.placement_constraints
}