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
output "endpoint" {
  value = try(
    "https://${nonsensitive(one(local.user_pass_pairs))}@${var.traefik.domain}",
    "http://${nonsensitive(one(local.user_pass_pairs))}@${docker_service.instance.name}:${docker_service.instance.endpoint_spec[0].ports[0].target_port}",
    "https://${var.traefik.domain}",
    "http://${docker_service.instance.name}:${docker_service.instance.endpoint_spec[0].ports[0].target_port}",
    null
  )
}
output "basic_auth_users" {
  value = local.user_pass_pairs
}
output "checksum" {
  value = sha512(jsonencode([
    docker_service.instance.id,
    docker_service.instance.name,
    docker_service.instance.task_spec[0].container_spec[0].image,
    coalesce(docker_service.instance.task_spec[0].container_spec[0].env, {}),
    [for c in module.config : c.checksum],
    var.ports,
    var.mounts,
    var.volumes,
    var.remote_volumes,
    var.networks,
    var.healthcheck,
  ]))
}