variable "domain" {
  type        = string
  description = "The domain to use for the service."
}
module "service" {
  source                = "../../docker/service"
  image                 = "beyondcodegmbh/expose-server:latest"
  service_name          = "expose"
  stack_name            = var.stack_name
  networks              = concat(var.networks, [module.network.network])
  traefik               = var.traefik
  placement_constraints = var.placement_constraints
  mounts                = var.mounts
  ports                 = var.ports
  converge_enable       = false
  environment_variables = {
    port     = 9090
    domain   = var.domain
    username = local.username
    password = local.password
  }
  volumes = {
    "expose_data" = "/root/.expose"
  }
}

