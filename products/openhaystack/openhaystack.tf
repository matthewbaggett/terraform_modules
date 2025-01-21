module "network" {
  source     = "../../docker/network"
  stack_name = var.stack_name
}
module "anisette" {
  source                = "../../docker/service"
  image                 = "dadoum/anisette-v3-server"
  stack_name            = var.stack_name
  service_name          = "anisette"
  networks              = concat(var.networks, [module.network])
  converge_enable       = false
  ports                 = [{ host = 6969, container = 6969, protocol = "tcp" }]
  placement_constraints = var.placement_constraints
  volumes = {
    "anisette-v3-data" = "/home/Alcoholic/.config/anisette-v3/lib/"
  }
}

module "macless-haystack" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "macless-haystack"
  image                 = "christld/macless-haystack"
  networks              = concat(var.networks, [module.network])
  converge_enable       = false
  ports                 = [{ host = 6176, container = 6176, protocol = "tcp" }]
  placement_constraints = var.placement_constraints
}