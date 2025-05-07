module "docker_registry_redis" {
  source                = "../../products/redis"
  stack_name            = var.stack_name
  networks              = [module.registry_network]
  placement_constraints = var.placement_constraints
  dns_nameservers       = var.dns_nameservers
}
