output "admin_user" {
  sensitive = true
  value = {
    admin = local.admin_user_password
  }
}
output "ldap_endpoint" {
  value = "ldap://${module.lldap.docker_service.name}:3890"
}
output "ldaps_endpoint" {
  value = "ldaps://${module.lldap.docker_service.name}:6360"
}
output "admin_username" {
  value = "admin"
}
output "admin_password" {
  sensitive = true
  value     = local.admin_user_password
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

output "user_accounts" {
  value = {
    for creds in var.user_accounts : creds.username => {
      username = creds.username
      dn = "uid=${creds.username},ou=people,${var.base_dn}"
      password = random_password.user_accounts[creds.username].result
    }
  }
}

output "service_accounts" {
  value = {
    for creds in var.service_accounts : creds.username => {
      username = creds.username
      dn = "uid=${creds.username},ou=people,${var.base_dn}"
      password = random_password.service_accounts[creds.username].result
    }
  }
}