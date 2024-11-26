module "network" {
  source       = "../network"
  network_name = "docker-socket-proxy"
  stack_name   = var.stack_name
}
module "service" {
  source                = "../service"
  image                 = "${var.docker_socket_proxy_image}:${var.docker_socket_proxy_version}"
  stack_name            = var.stack_name
  service_name          = var.service_name
  placement_constraints = concat(["node.role == manager"], var.placement_constraints)
  global                = true
  networks              = [module.network]
  mounts                = { "/var/run/docker.sock" = "/var/run/docker.sock" }
  environment_variables = {
    SWARM      = 1
    SERVICES   = 1
    CONTAINERS = 1
    TASKS      = 1
    NODES      = 1
    NETWORKS   = 1
  }
}
