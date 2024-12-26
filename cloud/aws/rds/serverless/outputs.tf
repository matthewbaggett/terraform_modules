locals {
  output_tenants = {
    for key, tenant in module.tenants : key => {
      username          = tenant.username
      database          = tenant.database
      password          = tenant.password
      connection_string = tenant.connection_string
    }
  }
}
output "tenants" {
  value = local.output_tenants
}
output "admin" {
  value = {
    username = local.admin_username
    password = local.admin_password
  }
}