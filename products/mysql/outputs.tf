output "root_password" {
  value = local.root_password
}
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
  value = "mysql://${local.username}:${local.password}@${module.service.service_name}:3306/${local.database}"
}