module "frigate" {
  source                = "../../docker/service"
  image                 = "ghcr.io/blakeblackshear/frigate:stable"
  stack_name            = var.stack_name
  service_name          = "frigate"
  mounts                = var.mounts
  placement_constraints = var.placement_constraints
  traefik               = var.traefik
  environment_variables = {
    FRIGATE_RTSP_PASSWORD = var.frigate_rtsp_password
  }
  labels          = var.labels
  converge_enable = false
}