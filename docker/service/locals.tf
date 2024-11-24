locals {
  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  service_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])

  # Define service labels en-masse
  labels = merge(var.labels, {
    "com.docker.stack.namespace"    = var.stack_name
    "com.docker.stack.image"        = data.docker_registry_image.image.name
    "ooo.grey.service.stack"        = var.stack_name
    "ooo.grey.service.name"         = var.service_name
    "ooo.grey.service.image"        = data.docker_registry_image.image.name
    "ooo.grey.service.image.digest" = data.docker_registry_image.image.sha256_digest
  })
}