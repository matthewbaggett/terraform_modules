module "docker_socket_proxy" {
  source     = "../../../docker/socket-proxy"
  stack_name = var.stack_name
  enable_all = true
}