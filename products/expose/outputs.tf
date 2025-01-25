output "docker_service" {
  value = module.service.docker_service
}
output "network" {
  value = module.network.network
}
output "endpoint" {
  value = module.service.endpoint
}
output "auth" {
  value = {
    username = local.username
    password = local.password
  }
}