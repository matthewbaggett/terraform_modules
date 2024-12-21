resource "local_file" "debug" {
  filename        = "${path.root}/.debug/docker/services/${local.service_name}.json"
  file_permission = "0600"
  content = nonsensitive(jsonencode({
    name  = local.service_name
    stack = var.stack_name
    #image = local.image
    build                 = var.build
    networks              = var.networks
    ports                 = var.ports
    configs               = var.configs
    traefik               = var.traefik
    placement_constraints = var.placement_constraints
    build_tags            = local.is_build ? local.tags : []
  }))
}