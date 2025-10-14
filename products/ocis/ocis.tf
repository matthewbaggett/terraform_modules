module "ocis" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "ocis"
  image                 = "${var.image}:${var.tag}"
  converge_enable       = false
  ports                 = [{ host = var.port, container = 9200 }]
  start_first           = false
  command               = ["/bin/sh", "-c", "ocis init || true; ocis server"]
  environment_variables = local.env
  placement_constraints = var.placement_constraints
  volumes = {
    "config" = "/etc/ocis"
    "data"   = "/var/lib/ocis"
  }
}
