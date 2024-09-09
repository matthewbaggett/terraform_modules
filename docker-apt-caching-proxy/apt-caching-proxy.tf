module "ap" {
  source                = "../docker-service"
  image                 = "sameersbn/apt-cacher-ng"
  stack_name            = "apt-caching-proxy"
  service_name          = "apt-caching-proxy"
  placement_constraints = var.placement_constraints
  ports = [
    {
      host      = var.port
      container = 3142
    }
  ]
}

