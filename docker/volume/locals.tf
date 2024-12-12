locals {
  volume_name = substr(join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.volume_name, 0, 64 - 1 - 3 - 20 - 6 - 6),
    formatdate("YYMMDD", plantimestamp()),
    formatdate("hhmmss", plantimestamp()),
  ]), 0, 63)

  labels = merge(var.labels, {
    "com.docker.stack.namespace" = var.stack_name
    "ooo.grey.volume.stack"      = var.stack_name
    "ooo.grey.volume.name"       = var.volume_name
    #"ooo.grey.volume.created"    = plantimestamp()
  })
}