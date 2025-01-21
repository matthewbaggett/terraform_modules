module "network" {
  source     = "../../docker/network"
  stack_name = var.stack_name
}
module "postgres" {
  source                = "../postgres"
  postgres_version      = "16"
  stack_name            = var.stack_name
  networks              = [module.network]
  username              = "postgres"
  database              = "postgres"
  placement_constraints = var.placement_constraints
  ports                 = [{ container = 5432, host = 65432 }]
}
module "service" {
  source       = "../../docker/service"
  image        = "${var.quassel_image}:${var.quassel_version}"
  stack_name   = var.stack_name
  service_name = "quassel"
  networks     = [module.network]
  environment_variables = {
    PUID               = 1000
    PGID               = 1000
    TZ                 = "Europe/Amsterdam"
    RUN_OPTS           = "--config-from-environment"
    DB_BACKEND         = "PostgreSQL"
    DB_PGSQL_USERNAME  = module.postgres.username
    DB_PGSQL_PASSWORD  = module.postgres.password
    DB_PGSQL_HOSTNAME  = module.postgres.service_name
    DB_PGSQL_PORT      = 5432
    AUTH_AUTHENTICATOR = "Database"
  }
  placement_constraints = var.placement_constraints
  ports                 = [{ container = 4242, host = 4242 }]
  converge_enable       = false # @todo MB: add healthcheck and fix this.
}
