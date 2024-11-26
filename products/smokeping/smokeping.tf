module "smokeping" {
  source       = "../../docker/service"
  stack_name   = "smokeping"
  service_name = "smokeping"
  image        = "linuxserver/smokeping:latest"
  volumes      = { "smokeping" = "/data" }
  environment_variables = {
    PUID = 1000
    PGID = 1000
    TZ   = var.timezone
  }
  traefik               = var.traefik
  networks              = ["loadbalancer-traefik"]
  placement_constraints = var.placement_constraints
}