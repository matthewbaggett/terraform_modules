locals {
  network_name = var.stack_name
  labels = merge(var.labels, {
    "com.docker.stack.namespace" = var.stack_name
    "ooo.grey.network.stack"     = var.stack_name
    "ooo.grey.network.name"      = local.network_name
    #"ooo.grey.network.created"    = timestamp()
  })
}