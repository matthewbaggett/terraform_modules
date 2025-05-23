variable "debug" {
  type        = bool
  default     = false
  description = "Enable debug mode"
}
variable "debug_path" {
  type        = string
  description = "Path to write debug files to"
  default     = null
}
locals {
  debug_path = var.debug_path != null ? var.debug_path : "${path.root}/.debug/docker/services/${var.stack_name}/${var.service_name}"
}
data "json-formatter_format_json" "debug" {
  count = var.debug ? 1 : 0
  json = nonsensitive(jsonencode({
    name                  = local.service_name
    stack                 = var.stack_name
    image                 = local.image_fully_qualified
    build                 = var.build
    networks              = local.network_ids
    ports                 = var.ports
    configs               = var.configs
    remote_configs        = var.remote_configs
    volumes               = var.volumes
    remote_volumes        = var.remote_volumes
    traefik               = var.traefik
    placement_constraints = var.placement_constraints
    build_tags            = local.is_build ? local.tags : []
    labels = {
      computed = local.labels,
      traefik  = local.traefik_labels,
      provided = var.labels,
      final    = local.merged_labels
    }
    environment_variables = var.environment_variables
  }))
}
resource "local_file" "debug" {
  count           = var.debug ? 1 : 0
  filename        = "${local.debug_path}/${var.service_name}.json"
  file_permission = "0600"
  content         = data.json-formatter_format_json.debug[0].result
}