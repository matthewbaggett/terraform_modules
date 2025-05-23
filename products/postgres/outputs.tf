output "hostname" {
  value = module.service.service_name
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
  value = "postgres://${local.username}:${local.password}@${module.service.service_name}:5432/${local.database}"
}
output "config" {
  value = {
    "hostname" = module.service.service_name
    "port"     = one(module.service.ports)
    "username" = local.username
    "password" = local.password
    "database" = local.database
  }
}
output "pgadmin_config" {
  value = {
    "Group"         = var.stack_name
    "Name"          = module.service.service_name
    "Host"          = module.service.service_name
    "Port"          = one(module.service.ports)
    "Username"      = local.username
    "MaintenanceDB" = local.database
    "Comment"       = "${var.stack_name} ${local.database} database"
  }
}