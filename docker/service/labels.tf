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
  traefik_rule = var.traefik != null ? "Host(\"${var.traefik.domain}\")" : null
  traefik_labels = merge(
    (var.traefik == null ? {
      "traefik.enable" = "false"
      } : {
      "traefik.enable"                                                              = "true"
      "traefik.http.routers.${local.service_name}.rule"                             = local.traefik_rule
      "traefik.http.routers.${local.service_name}.service"                          = "${local.service_name}"
      "traefik.http.routers.${local.service_name}.entrypoints"                      = "web"
      "traefik.http.routers.${local.service_name}_ssl.rule"                         = var.traefik.ssl ? local.traefik_rule : null
      "traefik.http.routers.${local.service_name}_ssl.service"                      = var.traefik.ssl ? "${local.service_name}_ssl" : null
      "traefik.http.routers.${local.service_name}_ssl.entrypoints"                  = var.traefik.ssl ? "websecure" : null
      "traefik.http.routers.${local.service_name}_ssl.tls.certresolver"             = var.traefik.ssl ? "default" : null
      "traefik.http.services.${local.service_name}.loadbalancer.passhostheader"     = "true"
      "traefik.http.services.${local.service_name}.loadbalancer.server.port"        = var.traefik.port
      "traefik.http.services.${local.service_name}_ssl.loadbalancer.passhostheader" = var.traefik.ssl ? "true" : null
      "traefik.http.services.${local.service_name}_ssl.loadbalancer.server.port"    = var.traefik.ssl ? var.traefik.port : null
    })
  )

}