output "registry_users" {
  value = local.registry_users
}
output "registry_user_login" {
  value = {
    for user, pass in local.registry_users : user => "docker login -u ${user} -p${pass} ${var.domain}"
  }
}
