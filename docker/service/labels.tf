locals {
  # Define service labels en-masse
  labels = merge({
    "com.docker.stack.namespace" = var.stack_name
    "com.docker.stack.image"     = data.docker_registry_image.image.name
    "ooo.grey.service.stack"     = var.stack_name
    "ooo.grey.service.name"      = var.service_name
    "ooo.grey.service.image"     = data.docker_registry_image.image.name
    #"ooo.grey.service.image.digest" = data.docker_registry_image.image.sha256_digest
  }, local.traefik_labels, var.labels)

  # Calculate the traefik labels to use if enabled
  traefik_labels = merge(
    (var.traefik == null ? {
      "traefik.enable" = "false"
      } : {
      "traefik.enable"                                              = "true"
      "traefik.http.routers.${local.service_name}.rule"             = "Host(`${var.traefik.domain}`)"
      "traefik.http.routers.${local.service_name}.entrypoints"      = var.traefik.ssl ? "web,websecure" : "web"
      "traefik.http.routers.${local.service_name}.tls.certresolver" = var.traefik.ssl ? "default" : ""
    }),
    (try(var.traefik.port, null) == null ? {} : {
      "traefik.http.services.${local.service_name}.loadbalancer.server.port" = var.traefik.port
    })
  )

}