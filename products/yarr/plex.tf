module "plex" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/plex"
  enable       = var.enabled
  service_name = "plex"
  stack_name   = var.stack_name
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "plex-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = merge(var.traefik, {
    domain      = "plex.${var.traefik.domain}"
    port        = 32400
    middlewares = ["forward-auth"]
  })
  placement_constraints = var.placement_constraints
  ports = [
    { container = 32469, host = 32469 },
    { container = 32400, host = 32400 },
    { container = 32401, host = 32401 },
    { container = 3005, host = 3005 },
    { container = 8324, host = 8324 },
    { container = 32410, host = 32410, protocol = "udp" },
    { container = 32412, host = 32412, protocol = "udp" },
    { container = 32413, host = 32413, protocol = "udp" },
    { container = 32414, host = 32414, protocol = "udp" },
  ]
}