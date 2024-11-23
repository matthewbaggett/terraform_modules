resource "docker_volume" "volume" {
  name = local.volume_name

  # Attach labels
  dynamic "labels" {
    for_each = local.labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}