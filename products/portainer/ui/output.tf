locals {
  credentials = {
    username = "admin" # Sorry, this is hardcoded in the portainer image
    password = nonsensitive(random_password.password.result)
  }
}
output "agent" {
  value = {
    credentials       = local.credentials
    portainer_version = var.portainer_version
    service_name      = module.portainer.docker_service.name
    network           = module.network
    stack_name        = var.stack_name
  }
}
output "credentials" {
  value = local.credentials
}
output "network" {
  value = module.network
}
output "endpoint" {
  value = module.portainer.endpoint
}
output "socket_proxy_endpoint" {
  value = module.docker_socket_proxy.endpoint
}