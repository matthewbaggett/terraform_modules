output "docker_service" {
  value = module.service.docker_service
}
output "network" {
  value = module.network
}
output "endpoint" {
  value = "tcp://${module.service.service_name}:2375"
}