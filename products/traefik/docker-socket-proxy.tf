module "docker_socket_proxy" {
  source                = "../../docker/socket-proxy"
  stack_name            = var.stack_name
  placement_constraints = ["node.role == manager"]
}