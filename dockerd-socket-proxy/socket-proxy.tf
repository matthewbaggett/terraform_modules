module "network" {
  source     = "../docker-network"
  name       = "docker-socket-proxy"
  stack_name = var.stack_name
}
module "service" {
  source       = "../docker-service"
  image        = "${var.docker_socket_proxy_image}:${var.docker_socket_proxy_version}"
  command      = ["/docker-entrypoint.sh", "sockd-username"]
  stack_name   = var.stack_name
  service_name = var.service_name
  environment_variables = {
    SWARM      = 1
    SERVICES   = 1
    CONTAINERS = 1
    TASKS      = 1
    NODES      = 1
    NETWORKS   = 1
  }
  placement_constraints = ["node.role == manager"]
  global                = true
  networks              = [module.network.network.id]
  mounts = [
    {
      target    = "/var/run/docker.sock"
      source    = "/var/run/docker.sock"
      read_only = false
      type      = "bind"
    }
  ]
}
output "network" {
  value = module.network.network
}