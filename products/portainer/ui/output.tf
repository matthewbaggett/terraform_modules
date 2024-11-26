output "portainer" {
  value = {
    credentials = {
      username = "admin" # Sorry, this is hardcoded in the portainer image
      password = nonsensitive(random_password.password.result)
    }
    service_name = module.portainer.docker_service.name
  }
}
