locals {
  output_tenants = {
    for key, tenant in module.tenants : key => {
      username          = tenant.username
      database          = tenant.database
      access_key        = tenant.access_key
      secret_key        = tenant.secret_key
      auth_token        = tenant.auth_token
      connection_string = tenant.connection_string
    }
  }
}
output "tenants" {
  value = local.output_tenants
}