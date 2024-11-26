module "traefik_network" {
  source       = "../../docker/network"
  stack_name   = var.stack_name
  network_name = "traefik"
  subnet       = "172.16.0.0/22"
}
