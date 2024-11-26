data "docker_registry_image" "frigate" {
  name = "ghcr.io/blakeblackshear/frigate:stable"
}

resource "docker_container" "frigate" {
  image        = "${data.docker_registry_image.frigate.name}@${data.docker_registry_image.frigate.sha256_digest}"
  name         = local.container_name
  restart      = "unless-stopped"
  privileged   = "true"
  shm_size     = var.shm_size_mb
  network_mode = "bridge"
  env = [
    "FRIGATE_RTSP_PASSWORD=${var.frigate_rtsp_password}"
  ]
  dynamic "devices" {
    for_each = var.devices
    content {
      host_path      = devices.value.host_path
      container_path = devices.value.container_path
      permissions    = devices.value.permissions
    }
  }
  dynamic "volumes" {
    for_each = var.volumes
    content {
      container_path = volumes.value
      host_path      = volumes.key
      read_only      = false
    }
  }
  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.container
      external = ports.value.host
      protocol = ports.value.protocol
    }
  }
  dynamic "networks_advanced" {
    for_each = var.networks
    content {
      name = networks_advanced.value
    }
  }
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