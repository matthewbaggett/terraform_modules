module "network" {
  source     = "../docker-network"
  stack_name = var.stack_name
}
module "postgres" {
  source                = "../docker-postgres"
  postgres_version      = "16"
  stack_name            = var.stack_name
  networks              = [module.network.network]
  placement_constraints = var.placement_constraints
  ports                 = [{ container = 5432, host = 65200 }]
}
data "docker_network" "loadbalancer" {
  name = "loadbalancer"
}

module "service" {
  source       = "../docker-service"
  image        = "${var.statping_image}:${var.statping_version}"
  stack_name   = var.stack_name
  service_name = "statping"
  networks = [
    module.network.network,
    data.docker_network.loadbalancer.id,
  ]
  environment_variables = {
    VIRTUAL_HOST = "localhost"
    VIRTUAL_PORT = "8080"
    DB_CONN      = "postgres"
    DB_HOST      = module.postgres.service_name
    DB_USER      = module.postgres.username
    DB_PASS      = module.postgres.password
    DB_DATABASE  = module.postgres.database
    NAME         = var.name
    DESCRIPTION  = var.description
  }
  placement_constraints = var.placement_constraints
}
