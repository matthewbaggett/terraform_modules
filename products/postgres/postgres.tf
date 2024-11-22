module "service" {
  source       = "../../docker/service"
  image        = "${var.postgres_image}:${var.postgres_version}"
  stack_name   = var.stack_name
  service_name = "postgres"
  networks     = var.networks
  healthcheck  = ["CMD-SHELL", "pg_isready", "-U", local.username, "-d", local.database]
  environment_variables = {
    POSTGRES_USER     = local.username
    POSTGRES_PASSWORD = local.password
    POSTGRES_DB       = local.database
  }
  volumes = {
    "data" = "/var/lib/postgresql/data",
  }
  ports                 = var.ports
  placement_constraints = var.placement_constraints
}