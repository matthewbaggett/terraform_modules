locals {
  shm_bytes = try(var.shm_size_mb * 1024 * 1024, 0)
}
resource "docker_volume" "shm" {
  for_each = local.shm_bytes > 0 ? { shm = {} } : {}
  name     = "${var.stack_name}-${var.service_name}-shm"
  driver   = "local"
  driver_opts = {
    "type"   = "tmpfs"
    "device" = "tmpfs"
    "o"      = "size=${local.shm_bytes}"
  }
}