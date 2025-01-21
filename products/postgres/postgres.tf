module "service" {
  source               = "../../docker/service"
  image                = "${var.postgres_image}:${var.postgres_version}"
  stack_name           = var.stack_name
  service_name             = var.service_name
  networks             = var.networks
  healthcheck          = ["CMD-SHELL", "pg_isready", "-U", local.username, "-d", local.database]
  healthcheck_interval = "10s"
  environment_variables = {
    POSTGRES_USER     = local.username
    POSTGRES_PASSWORD = local.password
    POSTGRES_DB       = local.database
  }
  volumes               = local.volumes
  mounts                = local.mounts
  ports                 = var.ports
  placement_constraints = var.placement_constraints
}

locals {
  volumes = var.data_persist_path == null ? {
    "data" = "/var/lib/postgres/data"
  } : {}
  mounts = var.data_persist_path != null ? {
    "${var.data_persist_path}" = "/var/lib/postgres/data"
  } : {}

}