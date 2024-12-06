module "registry_network" {
  source     = "../../docker/network"
  stack_name = "registry"
}
