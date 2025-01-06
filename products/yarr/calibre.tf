module "calibre" {
  source       = "../../docker/service"
  image        = "technosoft2000/calibre-web"
  service_name = "calibre"
  stack_name   = var.stack_name
  remote_volumes = {
    "/books" = module.media
  }
  volumes = {
    "calibre-config" = "/config"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = "calibre.${var.traefik.domain}"
    ssl         = true
    port        = 8083
    middlewares = ["forward-auth"]
  }
  placement_constraints = var.placement_constraints
}