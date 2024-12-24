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