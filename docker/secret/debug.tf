resource "local_file" "secret" {
  count           = var.debug ? 1 : 0
  content         = var.value
  filename        = "${local.debug_path}/${local.file_name}"
  file_permission = "0600"
}
variable "debug_path" {
  type        = string
  description = "Path to write debug files to"
  default     = null
}
locals {
  debug_path = var.debug_path != null ? var.debug_path : "${path.root}/.debug/docker/secrets/${var.stack_name}"
}