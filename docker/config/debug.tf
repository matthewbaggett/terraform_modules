variable "debug" {
  type        = bool
  default     = true
  description = "Emit debug files in .debug directory"
}
variable "debug_path" {
  type        = string
  description = "Path to write debug files to"
  default     = null
}
locals {
  debug_path = var.debug_path != null ? var.debug_path : "${path.root}/.debug/docker/configs/${var.stack_name}"
}
resource "local_file" "config" {
  count           = var.debug ? 1 : 0
  content         = var.value
  filename        = "${local.debug_path}/${local.file_name}"
  file_permission = "0600"
}
