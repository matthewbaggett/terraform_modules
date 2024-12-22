output "docker_service" {
  value = module.forgejo.docker_service
}
output "postgres" {
  value = module.postgres
}

output "endpoint" {
  value = module.forgejo.endpoint
}
output "network" {
  value = module.forgejo_network.network
}