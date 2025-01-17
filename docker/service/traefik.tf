variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, true)
    ssl              = optional(bool, false)
    rule             = optional(string)
    middlewares      = optional(list(string), [])
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string), [])
    headers          = optional(map(string), {})
  })
  description = "Whether to enable traefik for the service."
}
resource "random_password" "password" {
  for_each = toset(try(var.traefik.basic-auth-users, []))
  length   = 16
  special  = false
}
resource "random_password" "salt" {
  for_each         = toset(try(var.traefik.basic-auth-users, []))
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:?"
}
resource "htpasswd_password" "htpasswd" {
  for_each = toset(try(var.traefik.basic-auth-users, []))
  password = random_password.password[each.key].result
  salt     = random_password.salt[each.key].result
}
locals {
  is_traefik = var.traefik != null
  # Calculate the traefik labels to use if enabled
  traefik_service = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])
  traefik_basic_auth = (
    local.is_traefik
    ? (
      length(var.traefik.basic-auth-users) > 0
      ? {
        "traefik.http.middlewares.${local.traefik_service}-auth.basicauth.users" = join(",", [
          for user in var.traefik.basic-auth-users : "${user}:${htpasswd_password.htpasswd[user].bcrypt}"
        ])
      }
      : {}
    )
    : {}
  )
  traefik_headers = (
    local.is_traefik
    ? { for key, value in var.traefik.headers : "traefik.http.middlewares.${local.traefik_service}-headers.headers.customrequestheaders.${key}" => value }
    : {}
  )
  traefik_middlewares = concat(
    try(var.traefik.middlewares, []),
    length(local.traefik_basic_auth) > 0 ? ["${local.traefik_service}-auth"] : [],
    length(local.traefik_headers) > 0 ? ["${local.traefik_service}-headers"] : []
  )
  has_auth = length(keys(local.traefik_basic_auth)) > 0

  provided_middlewares = var.traefik != null ? var.traefik.middlewares : []
  auth_middleware      = local.has_auth ? "${local.traefik_service}-auth" : null
  traefik_middlewares  = compact(concat(local.provided_middlewares, [local.auth_middleware]))
  traefik_rule = (
    local.is_traefik
    ? (
      var.traefik.rule != null
      ? var.traefik.rule
      : "Host(`${var.traefik.domain}`)"
    )
    : null
  )
  traefik_entrypoints = compact(
    local.is_traefik
    ? [var.traefik.non-ssl ? "web" : null, var.traefik.ssl ? "websecure" : null]
    : []
  )
  traefik_labels = (
    local.is_traefik
    ? merge(
      {
        "traefik.enable"                                                             = "true"
        "traefik.http.routers.${local.traefik_service}.rule"                         = local.traefik_rule
        "traefik.http.routers.${local.traefik_service}.service"                      = local.traefik_service
        "traefik.http.routers.${local.traefik_service}.entrypoints"                  = join(",", local.traefik_entrypoints)
        "traefik.http.routers.${local.traefik_service}.tls.certresolver"             = var.traefik.ssl ? "default" : null
        "traefik.http.services.${local.traefik_service}.loadbalancer.passhostheader" = "true"
        "traefik.http.services.${local.traefik_service}.loadbalancer.server.port"    = var.traefik.port
        "traefik.http.routers.${local.traefik_service}.middlewares"                  = length(local.traefik_middlewares) > 0 ? join(",", local.traefik_middlewares) : null
      },
      (local.traefik_middlewares != null
        ? {
          "traefik.http.routers.${local.traefik_service}.middlewares"     = var.traefik.non-ssl ? join(",", local.traefik_middlewares) : null
          "traefik.http.routers.${local.traefik_service}-ssl.middlewares" = var.traefik.ssl ? join(",", local.traefik_middlewares) : null
        } : {}
      ),
      local.traefik_basic_auth,
      local.traefik_headers,
  ) : {})
}

data "docker_network" "traefik" {
  count = local.is_traefik ? 1 : 0
  name  = try(var.traefik.network.name, "loadbalancer-traefik")
}