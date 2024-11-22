module "network" {
  source     = "../../docker/network"
  stack_name = var.stack_name
}
resource "random_password" "encryption_key" {
  length  = 32
  special = false
}
module "pgbackweb" {
  source = "../../docker/service"
  image  = "${var.pgbackweb_image}:${var.pgbackweb_version}"
  environment_variables = {
    PBW_ENCRYPTION_KEY       = nonsensitive(random_password.encryption_key.result)
    PBW_POSTGRES_CONN_STRING = "postgres://${module.postgres.username}:${module.postgres.password}@${module.postgres.service_name}:5432?sslmode=disable"
  }
  stack_name            = var.stack_name
  service_name          = var.service_name
  networks              = concat([module.network.network], var.networks)
  placement_constraints = var.placement_constraints
}
module "postgres" {
  source                = "../postgres"
  postgres_version      = "16"
  stack_name            = var.stack_name
  networks              = [module.network.network]
  placement_constraints = var.placement_constraints
  database              = "pgbackweb"
  username              = "pgbackweb"
  ports                 = [{ container = 5432, host = 64000 }]
}
output "pgbackweb" {
  value = module.pgbackweb
}
output "database" {
  value = module.postgres
}