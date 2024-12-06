resource "random_id" "randomiser" {
  byte_length = 2
  keepers = {
    stack_name = var.stack_name
    data       = var.value
  }
}

resource "docker_config" "config" {
  name = local.config_name
  data = base64encode(var.value)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

