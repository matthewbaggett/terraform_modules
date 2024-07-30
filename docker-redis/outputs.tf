output "auth" {
  value = local.auth
}
output "service_name" {
  value = module.service.service_name
}
output "ports" {
  value = module.service.ports
}