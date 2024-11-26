module "homeassistant" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "homeassistant"
  image                 = var.default_image
  environment_variables = merge({ TZ = "Europe/London" }, var.environment_variables)
  mounts                = var.mounts
  networks              = var.networks
  placement_constraints = var.placement_constraints
  ports                 = [{ host = 8123, container = 8123 }]
  traefik               = var.traefik
  converge_timeout      = "5m"
}