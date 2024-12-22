output "docker_service" {
  value = module.pgbackweb.docker_service
}

output "postgres" {
  value = module.postgres
}

output "network" {
  value = module.network.network
}