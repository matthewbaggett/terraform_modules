output "statping" {
  value = {
    database = {
      username = module.postgres.username
      password = module.postgres.password
      database = module.postgres.database
      port     = module.postgres.ports[0]
    }
    statping = {
      instance = try("https://${var.traefik.domain}", "unknown")
    }
  }
}
output "endpoint" {
  value = module.statping.endpoint
}
output "postgres" {
  value = module.postgres
}
output "network" {
  value = module.network.network
}