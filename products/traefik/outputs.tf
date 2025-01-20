output "docker_service" {
  value = module.traefik.docker_service
}
output "docker_network" {
  value = module.traefik_network
}
output "endpoint" {
  value = module.traefik.endpoint
}