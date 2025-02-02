module "service" {
  source               = "../../docker/service"
  enable               = var.enable
  image                = "${var.postgres_image}:${var.postgres_version}"
  stack_name           = var.stack_name
  service_name         = var.service_name
  networks             = var.networks
  healthcheck          = ["CMD-SHELL", "pg_isready", "-d $${POSTGRES_DB}", "--host=${var.stack_name}-${var.service_name}", "-U $${POSTGRES_USER}", ]
  healthcheck_interval = "10s"
  environment_variables = {
    PGUSER            = local.username
    POSTGRES_USER     = local.username
    POSTGRES_PASSWORD = local.password
    POSTGRES_DB       = local.database
    PGDATA            = "/var/lib/postgres/data"
  }
  volumes               = local.volumes
  mounts                = local.mounts
  ports                 = var.ports
  placement_constraints = var.placement_constraints
  parallelism           = 1
  start_first           = false
}
locals {
  volumes = var.data_persist_path == null ? {
    "data" = "/var/lib/postgres/data"
  } : {}
  mounts = var.data_persist_path != null ? zipmap([var.data_persist_path], ["/var/lib/postgres/data"]) : {}
}