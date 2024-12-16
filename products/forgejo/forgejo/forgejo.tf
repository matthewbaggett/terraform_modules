
module "forgejo" {
  source                = "../../../docker/service"
  image                 = "${var.forgejo_image}:${var.forgejo_version}"
  stack_name            = var.stack_name
  service_name          = "forgejo"
  placement_constraints = var.placement_constraints
  networks              = concat(var.networks, [module.forgejo_network])
  configs = {
    "/data/gitea/conf/app.ini" = templatefile("${path.module}/app.ini.tpl", merge({
      name              = var.forgejo_name
      slogan            = var.forgejo_slogan
      domain            = var.traefik != null ? var.traefik.domain : ""
      email             = var.forgejo_email
      ssh_port          = var.ssh_port
      database_host     = module.postgres.docker_service.name
      database_port     = 5432
      database_database = module.postgres.database
      database_username = module.postgres.username
      database_password = module.postgres.password
    }))
  }
  mounts = merge(var.mounts, {
    "/etc/timezone"  = "/etc/timezone",
    "/etc/localtime" = "/etc/localtime",
  })
  environment_variables = {
    USER_UID = 1000
    USER_GID = 1000
  }
  start_first = false
  ports = [
    {
      host      = 222
      container = 222
    },
    {
      host      = 3000
      container = 3000
    },
  ]
  traefik = merge(var.traefik, { port = 3000 })
}