resource "docker_network" "instance" {
  name        = local.network_name
  driver      = "overlay"
  attachable  = true
  ipam_driver = "default"
  ipam_config {
    aux_address = {}
    subnet      = local.subnet
    gateway     = local.gateway
  }

  # Attach labels
  dynamic "labels" {
    for_each = local.labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  lifecycle {
    create_before_destroy = false
  }
}