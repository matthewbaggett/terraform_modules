module "ap" {
  source                = "../../docker/service"
  image                 = "sameersbn/apt-cacher-ng"
  stack_name            = "apt-caching-proxy"
  service_name          = "apt-caching-proxy"
  placement_constraints = var.placement_constraints
  mounts                = local.mounts
  traefik               = var.traefik
  ports = [
    {
      host         = var.port
      container    = 3142
      publish_mode = var.publish_mode
    }
  ]
}

locals {
  mounts = var.data_persist_path != null ? zipmap([var.data_persist_path], ["/var/cache/apt-cacher-ng"]) : {}
}