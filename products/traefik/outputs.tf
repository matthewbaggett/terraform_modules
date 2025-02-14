output "docker_service" {
  value = module.traefik.docker_service
}
output "docker_network" {
  value = module.network
}
output "endpoint" {
  value = module.traefik.endpoint
}
output "hello_endpoint" {
  value = try(module.traefik_hello[0].endpoint, null)
}