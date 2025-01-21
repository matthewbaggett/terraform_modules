module "readarr" {
  source       = "../../docker/service"
  image        = "lscr.io/linuxserver/readarr:develop"
  enable       = var.enabled
  service_name = "readarr"
  stack_name   = var.stack_name
  remote_volumes = {
    "/media" = module.media
  }
  volumes = {
    "readarr-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = "readarr.${var.traefik.domain}"
    ssl         = true
    port        = 8787
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}