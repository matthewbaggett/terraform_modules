output "username" {
  value = local.username
}
output "password" {
  value = local.password
}
output "database" {
  value = local.database
}
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
  value = "postgres://${local.username}:${local.password}@${module.service.service_name}:5432/${local.database}"
}