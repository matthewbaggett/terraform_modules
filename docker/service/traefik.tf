variable "traefik" {
  default = null
  type = object({
    domain      = string
    port        = optional(number)
    non-ssl     = optional(bool, true)
    ssl         = optional(bool, false)
    rule        = optional(string)
    middlewares = optional(list(string))
    network = optional(object({
      name = string
      id   = string
    }))
  })
  description = "Whether to enable traefik for the service."
}
locals {
  is_traefik = var.traefik != null
  # Calculate the traefik labels to use if enabled
  traefik_service = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])
  traefik_rule = (
    local.is_traefik
    ? (
      var.traefik.rule != null
      ? var.traefik.rule
      : (
        var.traefik.domain != null
        ? "Host(`${var.traefik.domain}`)"
        : null
      )
    ) : null
  )
  traefik_labels = (
    local.is_traefik
    ? merge({
      "traefik.enable"                                                             = "true"
      "traefik.http.routers.${local.traefik_service}.rule"                         = var.traefik.non-ssl ? local.traefik_rule : null
      "traefik.http.routers.${local.traefik_service}.service"                      = var.traefik.non-ssl ? local.traefik_service : null
      "traefik.http.routers.${local.traefik_service}.entrypoints"                  = var.traefik.non-ssl ? "web" : null
      "traefik.http.routers.${local.traefik_service}.tls"                          = var.traefik.non-ssl ? "" : null
      "traefik.http.services.${local.traefik_service}.loadbalancer.passhostheader" = var.traefik.non-ssl ? "true" : null
      "traefik.http.services.${local.traefik_service}.loadbalancer.server.port"    = var.traefik.non-ssl ? var.traefik.port : null

      "traefik.http.routers.${local.traefik_service}-ssl.rule"                         = var.traefik.ssl ? local.traefik_rule : null
      "traefik.http.routers.${local.traefik_service}-ssl.service"                      = var.traefik.ssl ? "${local.traefik_service}-ssl" : null
      "traefik.http.routers.${local.traefik_service}-ssl.entrypoints"                  = var.traefik.ssl ? "websecure" : null
      "traefik.http.routers.${local.traefik_service}-ssl.tls.certresolver"             = var.traefik.ssl ? "default" : null
      "traefik.http.services.${local.traefik_service}-ssl.loadbalancer.passhostheader" = var.traefik.ssl ? "true" : null
      "traefik.http.services.${local.traefik_service}-ssl.loadbalancer.server.port"    = var.traefik.ssl ? var.traefik.port : null
      },
      (var.traefik.middlewares != null
        ? {
          "traefik.http.routers.${local.traefik_service}.middlewares"     = join(",", var.traefik.middlewares)
          "traefik.http.routers.${local.traefik_service}-ssl.middlewares" = join(",", var.traefik.middlewares)
        } : {}
      )
  ) : {})
}

data "docker_network" "traefik" {
  count = local.is_traefik ? 1 : 0
  name  = try(var.traefik.network.name, "loadbalancer-traefik")
}