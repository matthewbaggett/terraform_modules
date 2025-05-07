module "mailcatcher" {
  source                = "../../docker/service"
  enable                = var.enable
  placement_constraints = var.placement_constraints
  stack_name            = var.stack_name
  service_name          = "mailcatcher"
  image                 = "dockage/mailcatcher"
  traefik               = { domain = var.domain, ssl = true, non-ssl = true, port = 1080 }
  converge_enable       = false
  healthcheck           = ["CMD", "wget", "-q", "--spider", "http://localhost:1080/"]
  ports = [
    { container = 1080, host = 1080, publish_mode = var.publish_mode },
    { container = 1025, host = 1025, publish_mode = var.publish_mode },
  ]
}