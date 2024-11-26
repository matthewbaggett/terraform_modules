resource "random_id" "randomiser" {
  byte_length = 2
}

resource "docker_config" "config" {
  name = local.config_name
  data = base64encode(var.value)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

