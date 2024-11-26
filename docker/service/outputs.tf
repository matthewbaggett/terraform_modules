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
    "https://${var.traefik.domain}",
    "http://${docker_service.instance.name}:${docker_service.instance.endpoint_spec[0].ports[0].target_port}",
    null
  )
}