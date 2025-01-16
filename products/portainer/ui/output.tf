output "portainer" {
  value = {
    credentials = {
      username = "admin" # Sorry, this is hardcoded in the portainer image
      password = nonsensitive(random_password.password.result)
    }
    service_name = module.portainer.docker_service.name
  }
}
output "network" {
  value = module.portainer_network
}
output "endpoint" {
  value = module.portainer.endpoint
}
output "socket_proxy_endpoint" {
  value = module.docker_socket_proxy.endpoint
}