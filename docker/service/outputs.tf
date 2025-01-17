output "service_name" {
  value = docker_service.instance.name
}
output "environment_variables" {
  value = docker_service.instance.task_spec[0].container_spec[0].env
}
output "ports" {
  value = docker_service.instance.endpoint_spec[0].ports[*].published_port
}
output "volumes" {
  value = docker_service.instance.task_spec[0].container_spec[0].mounts[*].source
}
output "docker_service" {
  value = docker_service.instance
}
locals {
  first_auth = (var.traefik != null
    ? (
      length(var.traefik.basic-auth-users) > 0
      ?
      "${try(var.traefik.basic-auth-users[0], null)}:${try(nonsensitive(random_password.password[var.traefik.basic-auth-users[0]].result), null)}@"
      : null
    ) : null
  )
}
output "endpoint" {
  value = try(
    "https://${local.first_auth}${var.traefik.domain}",
    "http://${local.first_auth}${docker_service.instance.name}:${docker_service.instance.endpoint_spec[0].ports[0].target_port}",
    "https://${var.traefik.domain}",
    "http://${docker_service.instance.name}:${docker_service.instance.endpoint_spec[0].ports[0].target_port}",
    null
  )
}

output "basic_auth_users" {
  value = var.traefik != null ? {
    for user in var.traefik.basic-auth-users : user => nonsensitive(htpasswd_password.htpasswd[user].bcrypt)
  } : {}
}