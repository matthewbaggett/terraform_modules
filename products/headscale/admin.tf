module "admin" {
  source       = "../../docker/service"
  image        = var.admin_image
  service_name = "admin"
  stack_name   = var.stack_name
  volumes = {
    "headscale-config" = "/var/lib/headscale"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain      = var.domain
    ssl         = true
    rule =
    port        = 80
  }
  placement_constraints = var.placement_constraints
}