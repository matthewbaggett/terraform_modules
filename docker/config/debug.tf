resource "local_file" "config" {
  count           = var.debug ? 1 : 0
  content         = var.value
  filename        = "${path.root}/.debug/docker/${var.stack_name}/configs/${local.file_name}"
  file_permission = "0600"
}