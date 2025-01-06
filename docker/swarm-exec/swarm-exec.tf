module "swarm_exec" {
  source       = "../service"
  image        = var.image
  stack_name   = var.stack_name
  service_name = var.service_name
  mounts       = { "/var/run/docker.sock" = "/var/run/docker.sock" }
  global       = true
  one_shot     = true
  command      = ["sh", "-c", var.command]
}
