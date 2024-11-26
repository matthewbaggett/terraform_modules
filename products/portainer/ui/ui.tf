resource "random_password" "password" {
  length = 32
}
resource "random_password" "salt" {
  length = 8
}
resource "htpasswd_password" "hash" {
  password = random_password.password.result
  salt     = random_password.salt.result
}
module "vol_portainer" {
  source      = "../../../docker/volume"
  stack_name  = var.stack_name
  volume_name = "portainer"
}
module "portainer" {
  source       = "../../../docker/service"
  stack_name   = var.stack_name
  service_name = "portainer"
  image        = "portainer/portainer-ce:${var.portainer_version}"
  command = [
    "/portainer",
    //"--edge-compute",
    "--logo", coalesce(var.portainer_logo),
    "--admin-password", htpasswd_password.hash.bcrypt,
  ]
  remote_volumes = {
    "/data" = module.vol_portainer.volume
  }
  traefik     = var.traefik
  mounts      = var.should_mount_local_docker_socket ? { "/var/run/docker.sock" = "/var/run/docker.sock" } : {}
  networks    = ["loadbalancer-traefik"]
  start_first = false
  placement_constraints = concat([
    "node.role == manager",
    "node.platform.os == linux",
  ], var.placement_constraints)
}
