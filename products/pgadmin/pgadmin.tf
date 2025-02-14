resource "random_password" "default" {
  length  = 32
  special = false
}
variable "servers" {
  type = list(object({
    Name                 = string
    Group                = optional(string)
    Host                 = string
    Port                 = number
    Username             = string
    SSLMode              = optional(string, "prefer")
    MaintenanceDB        = optional(string, "postgres")
    Comment              = optional(string, null)
    UseSSHTunnel         = optional(bool, null)
    TunnelHost           = optional(string, null)
    TunnelPort           = optional(number, null)
    TunnelUsername       = optional(string, null)
    TunnelAuthentication = optional(string, null)
  }))
}
module "pgadmin" {
  source                = "../../docker/service"
  enable                = var.enable
  image                 = "dpage/pgadmin4:8"
  service_name          = "pgadmin"
  stack_name            = "pgadmin"
  placement_constraints = var.placement_constraints
  networks              = var.networks
  traefik               = var.traefik
  environment_variables = {
    PGADMIN_DEFAULT_EMAIL    = var.email
    PGADMIN_DEFAULT_PASSWORD = nonsensitive(random_password.default.result)
  }
  configs = {
    "/pgadmin4/servers.json" = jsonencode({
      Servers = { for server in var.servers : index(var.servers, server) => server }
    })
  }
  #healthcheck              = ["CMD", "wget", "-q", "-O", "-", "http://localhost:80/misc/ping"]
  #healthcheck_start_period = "60s"
  #converge_timeout         = "5m"
  converge_enable = false
}
output "credentials" {
  value = {
    username = var.email
    password = nonsensitive(random_password.default.result)
  }
}