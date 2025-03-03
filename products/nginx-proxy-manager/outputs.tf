output "authentication" {
  value = {
    user = local.admin_email
    pass = nonsensitive(local.admin_password)
  }
}
output "postgres" {
  value = {
    username = module.postgres.username
    password = module.postgres.password
    database = module.postgres.database
    endpoint = module.postgres.endpoint
  }
}