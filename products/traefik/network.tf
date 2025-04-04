moved {
  from = module.traefik_network
  to   = module.network
}
module "network" {
  source       = "../../docker/network"
  stack_name   = var.stack_name
  network_name = "traefik"
  subnet       = "172.16.0.0/22"
}

data "docker_network" "traefik" {
  name = module.network.name
}