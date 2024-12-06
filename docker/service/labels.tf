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
  traefik_service = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])
  traefik_rule = (
    var.traefik != null
    ? (
      var.traefik.rule != null
      ? var.traefik.rule
      : (
        var.traefik.domain
        ? "Host(\"${var.traefik.domain}\")"
        : null
      )
    ) : null
  )
  traefik_labels = merge(
    (var.traefik == null ? {
      "traefik.enable" = "false"
      } : {
      "traefik.enable"                                                             = "true"
      "traefik.http.routers.${local.traefik_service}.rule"                         = local.traefik_rule
      "traefik.http.routers.${local.traefik_service}.service"                      = local.traefik_service
      "traefik.http.routers.${local.traefik_service}.entrypoints"                  = "web"
      "traefik.http.services.${local.traefik_service}.loadbalancer.passhostheader" = "true"
      "traefik.http.services.${local.traefik_service}.loadbalancer.server.port"    = var.traefik.port

      "traefik.http.routers.${local.traefik_service}_ssl.rule"                         = var.traefik.ssl ? local.traefik_rule : null
      "traefik.http.routers.${local.traefik_service}_ssl.service"                      = var.traefik.ssl ? "${local.traefik_service}_ssl" : null
      "traefik.http.routers.${local.traefik_service}_ssl.entrypoints"                  = var.traefik.ssl ? "websecure" : null
      "traefik.http.routers.${local.traefik_service}_ssl.tls.certresolver"             = var.traefik.ssl ? "default" : null
      "traefik.http.services.${local.traefik_service}_ssl.loadbalancer.passhostheader" = var.traefik.ssl ? "true" : null
      "traefik.http.services.${local.traefik_service}_ssl.loadbalancer.server.port"    = var.traefik.ssl ? var.traefik.port : null
    })
  )

}