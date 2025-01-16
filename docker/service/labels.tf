locals {
  labels = {
    "com.docker.stack.namespace" = var.stack_name
    # remove everything after the @ character onwards
    "com.docker.stack.image" = local.image
    "ooo.grey.service.stack" = var.stack_name
    "ooo.grey.service.name"  = var.service_name
    "ooo.grey.service.image" = local.image
  }
  merged_labels = { for key, value in merge(local.labels, local.traefik_labels, var.labels) : key => value if value != null }
}