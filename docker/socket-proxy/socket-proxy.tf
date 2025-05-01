module "network" {
  source       = "../../docker/network"
  network_name = "docker-socket-proxy"
  stack_name   = var.stack_name
}
module "service" {
  source                = "../../docker/service"
  image                 = "${var.docker_socket_proxy_image}:${var.docker_socket_proxy_version}"
  stack_name            = var.stack_name
  service_name          = var.service_name
  placement_constraints = concat(["node.role == manager"], var.placement_constraints)
  global                = var.global
  parallelism           = var.parallelism
  networks              = [module.network]
  mounts                = { "/var/run/docker.sock" = "/var/run/docker.sock" }
  environment_variables = {
    EVENTS         = 1
    PING           = 1
    VERSION        = 1
    AUTH           = var.enable_all || var.enable_auth ? 1 : 0
    SECRETS        = var.enable_all || var.enable_secrets ? 1 : 0
    POST           = var.enable_all || var.enable_write ? 1 : 0
    BUILD          = var.enable_all || var.enable_build ? 1 : 0
    COMMIT         = var.enable_all || var.enable_commit ? 1 : 0
    CONFIGS        = var.enable_all || var.enable_configs ? 1 : 0
    CONTAINERS     = var.enable_all || var.enable_containers ? 1 : 0
    ALLOW_START    = var.enable_all || var.enable_write ? 1 : 0
    ALLOW_STOP     = var.enable_all || var.enable_write ? 1 : 0
    ALLOW_RESTARTS = var.enable_all || var.enable_write ? 1 : 0
    DISTRIBUTION   = var.enable_all || var.enable_distribution ? 1 : 0
    EXEC           = var.enable_all || var.enable_exec ? 1 : 0
    GRPC           = var.enable_all || var.enable_grpc ? 1 : 0
    IMAGES         = var.enable_all || var.enable_images ? 1 : 0
    INFO           = var.enable_all || var.enable_info ? 1 : 0
    NETWORKS       = var.enable_all || var.enable_networks ? 1 : 0
    NODES          = var.enable_all || var.enable_nodes ? 1 : 0
    PLUGINS        = var.enable_all || var.enable_plugins ? 1 : 0
    SERVICES       = var.enable_all || var.enable_services ? 1 : 0
    SESSION        = var.enable_all || var.enable_session ? 1 : 0
    SWARM          = var.enable_all || var.enable_swarm ? 1 : 0
    SYSTEM         = var.enable_all || var.enable_system ? 1 : 0
    TASKS          = var.enable_all || var.enable_tasks ? 1 : 0
    VOLUMES        = var.enable_all || var.enable_volumes ? 1 : 0
  }
}

