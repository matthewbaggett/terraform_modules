locals {
  volume_name = var.volume_name_explicit ? var.volume_name : substr(join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.volume_name, 0, 64 - 1 - 3 - 20 - 6 - 6),
    formatdate("YYMMDD", plantimestamp()),
    formatdate("hhmmss", plantimestamp()),
  ]), 0, 63)

  is_bind = var.bind_path != null
  driver_opts = (
    var.driver_opts != {}
    ? var.driver_opts
    : (
      local.is_bind
      ? {
        "type"   = "none"
        "device" = var.bind_path
        "o"      = "bind"
      }
      : {}
    )
  )

  labels = merge(var.labels, {
    "com.docker.stack.namespace" = var.stack_name
    "ooo.grey.volume.stack"      = var.stack_name
    "ooo.grey.volume.name"       = var.volume_name
  })
}
