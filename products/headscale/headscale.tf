module "headscale" {
  source       = "../../docker/service"
  image        = var.image
  service_name = "headscale"
  stack_name   = var.stack_name
  volumes = {
    "headscale-config" = "/var/lib/headscale"
  }
  configs = {
    "/etc/headscale/config.yaml" = yamlencode(local.config)
  }
  networks        = [module.network]
  converge_enable = false
  command         = ["headscale", "serve"]
  traefik = {
    domain = var.domain
    ssl    = true
    rule   = "Host(`${var.domain}`) && !PathPrefix(`/admin`)"
    port   = 8080
  }
  placement_constraints = var.placement_constraints
}