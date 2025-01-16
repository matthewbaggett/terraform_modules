module "headscale" {
  source                = "../../docker/service"
  image                 = "matthewbaggett/headscale-alpine:latest"
  service_name          = "headscale"
  stack_name            = var.stack_name
  volumes               = { "headscale-config" = "/var/lib/headscale" }
  configs               = { "/etc/headscale/config.yaml" = yamlencode(local.config) }
  networks              = [module.network]
  converge_enable       = false
  command               = ["headscale", "serve"]
  placement_constraints = var.placement_constraints
  ports                 = [{ container = 9090 }, { container = 8080 }]
  traefik = {
    domain = var.domain
    ssl    = true
    rule   = "Host(`${var.domain}`) && !PathPrefix(`/manager`)"
    port   = 8080
  }
}