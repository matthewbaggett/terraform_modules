locals {
  listen  = var.mode == "tcp" ? "tcp-listen:${var.target.port},fork,reuseaddr" : "udp-listen:${var.target.port},fork,reuseaddr"
  connect = var.mode == "tcp" ? "tcp-connect:${var.target.host}:${var.target.port}" : "udp-connect:${var.target.host}:${var.target.port}"
  command = ["socat", local.listen, local.connect]
}
module "socat" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = var.service_name
  image                 = "alpine/socat:latest"
  command               = local.command
  traefik               = var.traefik != null ? merge({ port = var.target.port }, { for k, v in var.traefik : k => v if v != null }) : null
  converge_enable       = false
  placement_constraints = var.placement_constraints
  ports                 = var.ports
}
