module "admin" {
  source                = "../../docker/service"
  image                 = var.admin_image
  service_name          = "admin"
  stack_name            = var.stack_name
  configs               = { "/etc/headscale/config.yaml" = yamlencode(local.config) }
  placement_constraints = var.placement_constraints
  networks              = [module.network]
  converge_enable       = false
  ports                 = [{ container = 80 }]
  traefik = {
    domain  = var.domain
    ssl     = true
    non-ssl = true
    rule    = "Host(`${var.domain}`) && PathPrefix(`/manager`)"
    port    = 80
  }
  labels = {
    #"traefik.http.middlewares.stripprefix.stripprefix.prefixes" = "/manager"
    #"traefik.http.routers.headscale-admin-ssl.middlewares"      = "stripprefix"

  }
}