output "docker_service" {
  value = module.service.docker_service
}
output "network" {
  value = module.network
}
output "endpoint" {
  value = module.service.endpoint
}