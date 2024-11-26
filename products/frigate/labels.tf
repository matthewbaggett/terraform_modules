
locals {
  container_name = "frigate"
  # Define service labels en-masse
  labels = merge({
    "com.docker.stack.namespace"    = var.stack_name
    "com.docker.stack.image"        = data.docker_registry_image.frigate.name
    "ooo.grey.service.stack"        = var.stack_name
    "ooo.grey.service.name"         = local.container_name
    "ooo.grey.service.image"        = data.docker_registry_image.frigate.name
    "ooo.grey.service.image.digest" = data.docker_registry_image.frigate.sha256_digest
  }, local.traefik_labels, var.labels)

  # Calculate the traefik labels to use if enabled
  traefik_labels = var.traefik != null ? {
    "traefik.enable"                                                         = "true"
    "traefik.http.routers.${local.container_name}.rule"                      = "Host(`${var.traefik.domain}`)"
    "traefik.http.routers.${local.container_name}.entrypoints"               = "websecure"
    "traefik.http.routers.${local.container_name}.tls.certresolver"          = "default"
    "traefik.http.services.${local.container_name}.loadbalancer.server.port" = 5000
    } : {
    "traefik.enable" = "false"
  }
}