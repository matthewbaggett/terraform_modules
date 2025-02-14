variable "log_level" {
  default     = "warning"
  description = "The log level for redis"
  type        = string
  validation {
    error_message = "Must be one of debug, verbose, notice, warning or nothing."
    condition     = can(regex("^(debug|verbose|notice|warning|nothing)$", var.log_level))
  }
}
variable "save_every_n_seconds" {
  type        = number
  default     = 60
  description = "The number of seconds between save operations."
}
variable "save_every_n_changes" {
  type        = number
  default     = 1
  description = "The number of changes between save operations."
}
variable "append_only" {
  default     = true
  description = "Whether to use append-only mode."
  type        = bool
}
module "service" {
  source       = "../../docker/service"
  enable       = var.enable
  image        = "${var.redis_image}:${var.redis_version}"
  stack_name   = var.stack_name
  service_name = "redis"
  command = [
    "redis-server",
    "--requirepass", local.auth,
    "--appendonly", (var.append_only ? "yes" : "no"),
    "--save", var.save_every_n_seconds, var.save_every_n_changes,
    "--loglevel", var.log_level
  ]
  networks                 = var.networks
  healthcheck              = ["CMD", "redis-cli", "ping"]
  healthcheck_interval     = "10s"
  healthcheck_start_period = "10s"
  volumes                  = { "data" = "/data", }
  ports                    = var.ports
  placement_constraints    = var.placement_constraints
  parallelism              = 1
  start_first              = false
}