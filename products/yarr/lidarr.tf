module "lidarr" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/lidarr:latest"
  enable       = var.enabled
  service_name = "lidarr"
  stack_name   = var.stack_name
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "lidarr-config" = "/config"
  }
  mounts = {
    "/etc/localtime" = "/etc/localtime"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = "lidarr.${var.traefik.domain}"
    ssl         = true
    port        = 8686
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}