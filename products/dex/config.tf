module "config" {
  source     = "../../docker/config"
  stack_name = var.stack_name
  name       = "dex"
  value = yamlencode({
    issuer = "https://${try(var.traefik.domain, "example.com")}"
    storage = {
      type = "postgres"
      config = {
        host     = module.postgres.service_name
        port     = 5432
        database = module.postgres.database
        user     = module.postgres.username
        password = module.postgres.password
        ssl = {
          mode = "disable"
        }
      }
    }
    web              = { http = "0.0.0.0:5556" }
    oauth2           = { skipApprovalScreen = true }
    staticClients    = local.staticClients
    staticPasswords  = local.staticPasswords
    enablePasswordDB = true
  })
}
