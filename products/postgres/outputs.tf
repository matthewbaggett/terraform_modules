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