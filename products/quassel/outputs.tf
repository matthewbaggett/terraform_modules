output "configuration" {
  value = {
    database = {
      username = module.postgres.username
      password = module.postgres.password
      database = module.postgres.database
      port     = module.postgres.ports[0]
    }
    quassel = {
      port = module.service.ports[0]
    }
  }
}
output "docker_service" {
  value = module.service.docker_service
}
output "postgres_service" {
  value = module.postgres.docker_service
}
output "postgres" {
  value = module.postgres
}