module "service" {
  source       = "../docker-service"
  image        = "${var.redis_image}:${var.redis_version}"
  command      = ["redis-server", "--requirepass", local.auth, "--appendonly", "yes", "--save", 60, 1, "--loglevel", "warning"]
  stack_name   = var.stack_name
  service_name = "redis"
  networks     = var.networks
  volumes = {
    "data" = "/data",
  }
  ports                 = var.ports
  placement_constraints = var.placement_constraints
}