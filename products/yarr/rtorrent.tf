module "rtorrent" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/rutorrent"
  service_name = "rtorrent"
  stack_name   = var.stack_name
  ports        = [{ container = 36258, host = 36258 }]
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "rtorrent-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  #healthcheck = ["CMD-SHELL","nc -z localhost 36258"]
  traefik = {
    domain      = "rtorrent.${var.traefik.domain}"
    ssl         = true
    port        = 80
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}