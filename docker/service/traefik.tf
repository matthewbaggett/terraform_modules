variable "traefik" {
  description = "Whether to enable traefik for the service."
  default     = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, false)
    ssl              = optional(bool, false)
    rule             = optional(string)
    middlewares      = optional(list(string), [])
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string), [])
    headers          = optional(map(string), {})
    udp_entrypoints  = optional(list(string), []) # List of UDP entrypoints
  })
}
resource "random_password" "password" {
  for_each = toset(local.user_accounts)
  length   = 16
  special  = false
}
resource "random_password" "salt" {
  for_each         = random_password.password
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:?"
}
resource "htpasswd_password" "htpasswd" {
  for_each = toset(local.user_accounts)
  password = random_password.password[each.key].result
  salt     = random_password.salt[each.key].result
}
locals {
  user_accounts     = try(var.traefik.basic-auth-users, [])
  user_pass_pairs   = formatlist("%s:%s", [for user, password in random_password.password : user], [for user, password in random_password.password : password.result])
  user_bcrypt_pairs = formatlist("%s:%s", [for user, htpasswd in htpasswd_password.htpasswd : user], [for user, htpasswd in htpasswd_password.htpasswd : htpasswd.bcrypt])
}
locals {
  is_traefik = var.traefik != null
  is_http    = try(var.traefik.non-ssl || var.traefik.ssl, false)
  is_udp     = length(try(var.traefik.udp_entrypoints, [])) > 0
  traefik_service = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])
  traefik_labels_basic_auth = {
    "traefik.http.middlewares.${local.traefik_service}-auth.basicauth.users"        = local.is_traefik && length(local.user_accounts) > 0 ? join(",", local.user_bcrypt_pairs) : null
    "traefik.http.middlewares.${local.traefik_service}-auth.basicauth.removeheader" = local.is_traefik ? (length(local.user_bcrypt_pairs) > 0 ? "true" : "false") : null
  }
  traefik_labels_headers = (
    local.is_traefik
    ? { for key, value in var.traefik.headers : "traefik.http.middlewares.${local.traefik_service}-headers.headers.customrequestheaders.${key}" => value }
    : {}
  )
  has_auth    = length(local.user_accounts) > 0 && length(local.traefik_labels_basic_auth) > 0
  has_headers = length(local.traefik_labels_headers) > 0
  traefik_middlewares = distinct(compact(concat(
    try(var.traefik.middlewares, []),
    local.has_auth ? ["${local.traefik_service}-auth"] : [],
    local.has_headers ? ["${local.traefik_service}-headers"] : []
  )))

  traefik_rule = (
    local.is_traefik
    ? (
      var.traefik.rule != null
      ? var.traefik.rule
      : try("Host(`${var.traefik.domain}`)", null)
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
        "traefik.enable" = "true"
      },
      local.is_http ? {
        "traefik.http.routers.${local.traefik_service}.rule"                         = local.traefik_rule
        "traefik.http.routers.${local.traefik_service}.service"                      = local.traefik_service
        "traefik.http.routers.${local.traefik_service}.entrypoints"                  = join(",", local.traefik_entrypoints)
        "traefik.http.routers.${local.traefik_service}.tls.certresolver"             = var.traefik.ssl ? "default" : null
        "traefik.http.routers.${local.traefik_service}.tls"                          = var.traefik.non-ssl ? "" : null
        "traefik.http.routers.${local.traefik_service}.middlewares"                  = length(local.traefik_middlewares) > 0 ? join(",", local.traefik_middlewares) : null
        "traefik.http.services.${local.traefik_service}.loadbalancer.passhostheader" = "true"
        "traefik.http.services.${local.traefik_service}.loadbalancer.server.port"    = var.traefik.port
      } : {},
      local.is_udp ? {
        "traefik.udp.routers.${local.traefik_service}.service"                   = local.traefik_service
        "traefik.udp.routers.${local.traefik_service}.entrypoints"               = join(",", var.traefik.udp_entrypoints)
        "traefik.udp.services.${local.traefik_service}.loadbalancer.server.port" = var.traefik.port
      } : {},
      local.traefik_labels_basic_auth,
      local.traefik_labels_headers,
      ) : {
      "traefik.enable" = "false"
  })
}

data "docker_network" "traefik" {
  count = local.is_traefik ? 1 : 0
  name  = try(var.traefik.network.name, "loadbalancer-traefik")
}