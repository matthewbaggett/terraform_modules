output "docker_service" {
  value = module.pgbackweb.docker_service
}

output "postgres_service" {
  value = module.postgres.docker_service
}