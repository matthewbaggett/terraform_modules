module "network" {
  source     = "../../docker/network"
  stack_name = var.stack_name
}
module "dex" {
  source       = "../../docker/service"
  depends_on   = [module.postgres]
  stack_name   = var.stack_name
  service_name = "dex"
  image        = "dexidp/dex"
  command      = ["dex", "serve", "/config.yml"]
  mounts = {
    "/etc/localtime" = "/etc/localtime"
  }
  remote_configs = {
    "/config.yml" = module.config
  }
  networks              = [module.network]
  traefik               = merge(var.traefik, { port = 5556 })
  placement_constraints = var.placement_constraints
}
