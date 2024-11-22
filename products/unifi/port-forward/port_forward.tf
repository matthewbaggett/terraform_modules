resource "unifi_port_forward" "port_forward" {
  count    = var.enabled ? 1 : 0
  name     = var.label
  dst_port = var.port_to != null ? var.port_to : var.port
  fwd_port = var.port_from != null ? var.port_from : var.port
  protocol = var.protocol
  fwd_ip   = var.ip
}