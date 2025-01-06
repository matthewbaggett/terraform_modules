module "radarr" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/radarr:latest"
  service_name = "radarr"
  stack_name   = var.stack_name
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "radarr-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = "radarr.${var.traefik.domain}"
    ssl         = true
    port        = 7878
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}