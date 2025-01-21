module "service" {
  source                   = "../../docker/service"
  image                    = "${var.mysql_image}:${var.mysql_version}"
  stack_name               = var.stack_name
  service_name             = "mysql"
  networks                 = var.networks
  healthcheck              = ["CMD", "/usr/local/bin/healthcheck.sh", "--connect", "--mariadbupgrade", "--innodb_initialized"]
  healthcheck_start_period = "10s"
  healthcheck_interval     = "10s"
  healthcheck_timeout      = "5s"
  healthcheck_retries      = 3
  environment_variables = {
    MARIADB_ROOT_PASSWORD = local.root_password
    MARIADB_USER          = local.username
    MARIADB_PASSWORD      = local.password
    MARIADB_DATABASE      = local.database
  }
  volumes               = local.volumes
  mounts                = local.mounts
  ports                 = var.ports
  placement_constraints = var.placement_constraints
}

locals {
  volumes = var.data_persist_path == null ? {
    "data" = "/var/lib/mysql"
  } : {}
  mounts = var.data_persist_path != null ? {
    "${var.data_persist_path}" = "/var/lib/mysql"
  } : {}

}