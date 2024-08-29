module "watchtower" {
  source                = "../docker-service"
  image                 = "containrrr/watchtower:latest"
  stack_name            = "watchtower"
  service_name          = "watchtower"
  placement_constraints = var.placement_constraints + ["node.role == manager"]
  command               = ["--cleanup", "--label-enable", "--interval", "3600"]
  labels = {
    "com.centurylinklabs.watchtower.enable" = "true"
  }
  volumes = {
    "/var/run/docker.sock" = "/var/run/docker.sock"
  }
}
