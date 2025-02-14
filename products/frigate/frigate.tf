module "frigate" {
  source                = "../../docker/service"
  enable                = var.enable
  image                 = "ghcr.io/blakeblackshear/frigate:stable"
  stack_name            = var.stack_name
  service_name          = "frigate"
  mounts                = var.mounts
  placement_constraints = var.placement_constraints
  traefik               = var.traefik
  environment_variables = {
    FRIGATE_RTSP_PASSWORD = var.frigate_rtsp_password
  }
  networks        = var.networks
  labels          = var.labels
  converge_enable = false
}