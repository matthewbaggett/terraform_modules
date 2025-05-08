locals {
  docker_socket_parallelism = var.docker_socket_instance_count != null ? var.docker_socket_instance_count : 1
  docker_socket_global      = var.docker_socket_instance_count == null ? true : false
}
module "docker_socket_proxy" {
  source                = "../../docker/socket-proxy"
  stack_name            = var.stack_name
  placement_constraints = ["node.role == manager"]
  parallelism           = local.docker_socket_parallelism
  global                = local.docker_socket_global
}