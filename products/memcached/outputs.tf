output "service_name" {
  value = module.service.service_name
}
output "ports" {
  value = module.service.ports
}
output "docker_service" {
  value = module.service.docker_service
}
output "endpoint" {
  value = "memcached://${module.service.service_name}:11211/"
}