output "docker_service" {
  value = module.minio.docker_service
}
output "endpoint" {
  value = try(
    "https://${var.traefik.domain}",
    "https://${var.domain}",
    null
  )
}
output "network" {
  value = module.network.network
}
output "minio" {
  value = {
    endpoint = "https://${var.domain}/ui/"
    auth = {
      username = module.minio.docker_service.task_spec[0].container_spec[0].env.MINIO_ROOT_USER
      password = nonsensitive(module.minio.docker_service.task_spec[0].container_spec[0].env.MINIO_ROOT_PASSWORD)
    }
  }
}
