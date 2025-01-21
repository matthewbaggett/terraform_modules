module "mylar" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/mylar3:latest"
  enable       = var.enabled
  service_name = "mylar"
  stack_name   = var.stack_name
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "mylar-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = "mylar.${var.traefik.domain}"
    ssl         = true
    port        = 8090
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}