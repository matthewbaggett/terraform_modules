module "service" {
  source       = "../../docker/service"
  enable       = var.enable
  image        = "${var.memcached_image}:${var.memcached_version}"
  stack_name   = var.stack_name
  service_name = var.service_name
  networks     = var.networks
  command      = ["memcached", "-m", var.memory_limit_mb, "-t", var.threads, "-c", var.connection_limit]
  #healthcheck              = ["CMD-SHELL", "echo \"version\" | nc -vn -w 1 127.0.0.1 11211"]
  #healthcheck_start_period = "10s"
  #healthcheck_interval     = "10s"
  #healthcheck_timeout      = "5s"
  #healthcheck_retries      = 3
  converge_enable       = false # @todo MB: fix healthcheck and fix this.
  ports                 = var.ports
  placement_constraints = var.placement_constraints
}
