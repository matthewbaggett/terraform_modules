locals {
  // Concat up the network name
  network_name = var.network_name != null ? "${var.stack_name}-${var.network_name}" : var.stack_name

  // Attach labels
  labels = merge(var.labels, {
    "com.docker.stack.namespace" = var.stack_name
    "ooo.grey.network.stack"     = var.stack_name
    "ooo.grey.network.name"      = local.network_name
    "ooo.grey.network.subnet"    = local.subnet
  })
}