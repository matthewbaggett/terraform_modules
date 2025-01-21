module "service" {
  source                   = "../../docker/service"
  image                    = "${var.memcached_image}:${var.memcached_version}"
  stack_name               = var.stack_name
  service_name             = var.service_name
  networks                 = var.networks
  command                  = ["memcached", "--memory-limit", var.memory_limit_mb, "--threads", var.threads, "--connection-limit", var.connection_limit]
  #healthcheck              = ["CMD-SHELL", "echo \"version\" | nc -vn -w 1 127.0.0.1 11211"]
  #healthcheck_start_period = "10s"
  #healthcheck_interval     = "10s"
  #healthcheck_timeout      = "5s"
  #healthcheck_retries      = 3
  converge_enable = false # @todo MB: fix healthcheck and fix this.
  volumes                  = local.volumes
  mounts                   = local.mounts
  ports                    = var.ports
  placement_constraints    = var.placement_constraints
}

locals {
  volumes = var.data_persist_path == null ? {
    "data" = "/var/lib/mysql"
  } : {}
  mounts = var.data_persist_path != null ? {
    "${var.data_persist_path}" = "/var/lib/mysql"
  } : {}

}