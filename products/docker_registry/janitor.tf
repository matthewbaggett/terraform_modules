
module "docker_registry_janitor" {
  source       = "../../docker/service"
  stack_name   = var.stack_name
  service_name = "janitor"
  image        = "registry:2"
  command = ["registry", "garbage-collect", "/etc/docker/registry/config.yml", "--delete-untagged"]
  configs = {
    "/etc/docker/registry/config.yml" = yamlencode(local.registry_config_yaml)
    "/etc/docker/registry/htpasswd"   = local.registry_htpasswd
  }
  restart_policy        = "any"
  restart_delay         = "6h"
  placement_constraints = var.placement_constraints
  networks              = [module.registry_network]
}
