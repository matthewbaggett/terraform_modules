output "statping" {
  value = {
    database = {
      username = module.postgres.username
      password = module.postgres.password
      database = module.postgres.database
      port     = module.postgres.ports[0]
    }
    statping = {
      instance = var.nginx_hostname != null ? "https://${var.nginx_hostname}" : null
    }
  }
}
