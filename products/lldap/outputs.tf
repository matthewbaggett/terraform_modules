output "admin_user" {
  sensitive = true
  value = {
    admin = local.admin_password
  }
}
locals {
  ldap_endpoint = "ldap://${module.lldap.docker_service.name}"
    ldaps_endpoint = "ldaps://${module.lldap.docker_service.name}"
}
output "ldap_endpoint" {
  value = local.ldap_endpoint
}
output "ldaps_endpoint" {
  value = local.ldaps_endpoint
}
output "admin_username" {
  value = var.admin_username
}
output "admin_password" {
  sensitive = true
  value     = local.admin_password
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
      dn       = "uid=${creds.username},ou=people,${var.base_dn}"
      password = random_password.user_accounts[creds.username].result
    }
  }
}

output "service_accounts" {
  value = {
    for creds in var.service_accounts : creds.username => {
      username = creds.username
      dn       = "uid=${creds.username},ou=people,${var.base_dn}"
      password = random_password.service_accounts[creds.username].result
    }
  }
}

output "ca_private_key" {
  value = tls_private_key.ca_private_key.private_key_pem
}
output "ca_cert" {
  value = tls_self_signed_cert.ca_cert.cert_pem
}
output "lldap_cert" {
  value = tls_locally_signed_cert.lldap_cert.cert_pem
}
