resource "docker_network" "instance" {
  name   = local.network_name
  driver = "overlay"

  # Attach labels
  dynamic "labels" {
    for_each = local.labels
    content {
      label = labels.key
      value = labels.value
    }
  }
}