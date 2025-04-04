moved {
  from = module.portainer_network
  to   = module.network
}
module "network" {
  source       = "../../../docker/network"
  stack_name   = var.stack_name
  network_name = "portainer"
}