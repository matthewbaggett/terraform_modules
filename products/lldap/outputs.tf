output "admin_user" {
  sensitive = true
  value = {
    admin = local.admin_user_password
  }
}
output "endpoint" {
  value = module.lldap.endpoint
}
output "network" {
  value = module.network
}
output "database_url_string" {
  value = local.database_url_string
}
output "base_dn" {
  value = var.base_dn
}
output "docker_service" {
  value = module.lldap.docker_service
}