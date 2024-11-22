output "quassel" {
  value = {
    database = {
      username = module.postgres.username
      password = module.postgres.password
      database = module.postgres.database
      port     = module.postgres.ports[0]
    }
    quassel = {
      port = module.service.ports[0]
    }
  }
}