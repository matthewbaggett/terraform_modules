module "port_forward" {
  source  = "../port-forward"
  enabled = var.enabled
  label   = var.label
  port_to = var.port != null ? var.port : var.docker_service.endpoint_spec[0].ports[0].published_port
  ip      = var.target.fixed_ip
}