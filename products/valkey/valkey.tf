variable "log_level" {
  default     = "warning"
  description = "The log level for redis"
  type        = string
  validation {
    error_message = "Must be one of debug, verbose, notice, warning or nothing."
    condition     = can(regex("^(debug|verbose|notice|warning|nothing)$", var.log_level))
  }
}
module "service" {
  source                   = "../../docker/service"
  enable                   = var.enable
  image                    = "${var.redis_image}:${var.redis_version}"
  stack_name               = var.stack_name
  service_name             = "valkey"
  command                  = ["valkey-server", "--loglevel", var.log_level]
  networks                 = var.networks
  healthcheck              = ["CMD", "valkey-cli", "ping"]
  healthcheck_interval     = "10s"
  healthcheck_start_period = "10s"
  volumes                  = { "data" = "/data", }
  ports                    = var.ports
  placement_constraints    = var.placement_constraints
  parallelism              = 1
  start_first              = false
  dns_nameservers          = var.dns_nameservers
}