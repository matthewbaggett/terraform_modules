module "service" {
  source                = "../../docker/service"
  image                 = "linuxserver/ddclient"
  service_name          = "ddclient"
  stack_name            = var.stack_name
  placement_constraints = var.placement_constraints
  #configs = {
  #  "/defaults/ddclient.conf" = templatefile("${path.module}/ddclient.conf.tpl", {
  #    protocol     = var.protocol
  #    login        = var.login
  #    password     = var.password
  #    apikey       = var.apikey
  #    secretapikey = var.secretapikey
  #  })
  #}
  secrets = {
    "/defaults/ddclient.conf" = templatefile("${path.module}/ddclient.conf.tpl", {
      protocol     = var.protocol
      router       = var.router
      login        = var.login
      password     = var.password
      apikey       = var.apikey
      secretapikey = var.secretapikey
      domain       = var.domain
    })
  }
  environment_variables = {
    PUID = 1000
    PGID = 1000
  }
  converge_enable = false # @todo Add healthcheck and enable this.
}
