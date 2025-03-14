output "docker_service" {
  value = module.service.docker_service
}
output "network" {
  value = module.network.network
}
output "endpoint" {
  value = replace(module.service.endpoint, "http://", "mqtt://")
}