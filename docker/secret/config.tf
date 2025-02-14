resource "random_id" "randomiser" {
  byte_length = 2
  keepers = {
    stack_name = var.stack_name
    data       = var.value
  }
}

resource "docker_secret" "secret" {
  name = local.secret_name
  data = base64encode(var.value)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

