module "pruner" {
  source       = "../service"
  stack_name   = var.stack_name
  service_name = "pruner"
  image        = "matthewbaggett/pruner:latest"
  global       = true
  environment_variables = {
    INTERVAL_SECONDS = 21600 // About every 6 hours
  }
  mounts         = { "/var/run/docker.sock" = "/var/run/docker.sock" }
  restart_policy = "any"
}
