module "network" {
  source       = "../../docker/network"
  stack_name   = var.stack_name
  network_name = "nextcloud"
}