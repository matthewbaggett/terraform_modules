module "service" {
  source                = "../../docker/service"
  image                 = "eclipse-mosquitto:latest"
  service_name          = "mqtt"
  stack_name            = var.stack_name
  networks              = concat(var.networks, [module.network.network])
  traefik               = var.traefik
  placement_constraints = var.placement_constraints
  mounts                = var.mounts
  ports                 = var.ports
  configs = {
    "/mosquitto/config/mosquitto.conf" = templatefile("${path.module}/mosquitto.conf", {})
  }
  volumes = {
    "mqtt_data" = "/mosquitto/data"
    "mqtt_logs" = "/mosquitto/logs"
  }
  converge_enable = false # @todo Add healthcheck and enable this.
}
