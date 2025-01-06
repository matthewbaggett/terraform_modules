module "sonarr" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/sonarr:latest"
  service_name = "sonarr"
  stack_name   = var.stack_name
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "sonarr-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = "sonarr.${var.traefik.domain}"
    ssl         = true
    port        = 8989
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}