variable "debug_path" {
  type        = string
  description = "Path to write debug files to"
  default     = null
}
locals {
  debug_path = var.debug_path != null ? var.debug_path : "${path.root}/.debug/docker/services/${var.stack_name}/${var.service_name}"
}
resource "local_file" "debug" {
  filename        = "${local.debug_path}/service.json"
  file_permission = "0600"
  content = nonsensitive(jsonencode({
    name                  = local.service_name
    stack                 = var.stack_name
    image                 = local.image_fully_qualified
    build                 = var.build
    networks              = var.networks
    ports                 = var.ports
    configs               = var.configs
    traefik               = var.traefik
    placement_constraints = var.placement_constraints
    build_tags            = local.is_build ? local.tags : []
  }))
}