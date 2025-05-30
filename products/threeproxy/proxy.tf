resource "random_pet" "username" {
  length = 3
}
resource "random_password" "password" {
  length  = 32
  special = false
}
locals {
  username       = replace(random_pet.username.id, "-", "")
  password       = nonsensitive(random_password.password.result)
  socks_endpoint = "socks5h://${local.username}:${local.password}@${var.endpoint}:${var.socks_proxy_port}"
  http_endpoint  = "http://${local.username}:${local.password}@${var.endpoint}:${var.http_proxy_port}"
}
module "service" {
  source       = "../../docker/service"
  image        = "${var.threeproxy_image}:${var.threeproxy_version}"
  stack_name   = var.stack_name
  service_name = var.service_name
  environment_variables = {
    PROXY_LOGIN        = local.username
    PROXY_PASSWORD     = local.password
    PRIMARY_RESOLVER   = "8.8.8.8"
    SECONDARY_RESOLVER = "4.2.2.4"
  }
  placement_constraints = var.placement_constraints
  ports = [
    {
      host      = var.socks_proxy_port
      container = 1080
      }, {
      host      = var.http_proxy_port
      container = 3128
    }
  ]
}
