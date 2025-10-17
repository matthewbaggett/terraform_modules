module "garage" {
  source          = "../../docker/service"
  stack_name      = var.stack_name
  service_name    = var.service_name
  image           = "${var.image}:${var.tag}"
  converge_enable = false
  ports = [
    {
      host      = var.rpc_port
      container = var.rpc_port
      }, {
      host      = var.web_port
      container = var.web_port
      }, {
      host      = var.s3_port
      container = var.s3_port
      }, {
      host      = var.admin_port
      container = var.admin_port
    }
  ]
  placement_constraints = var.placement_constraints
  mounts = {
    "/data/garage/meta" = "/var/lib/garage/meta"
    "/data/garage/data" = "/var/lib/garage/data"
  }
  configs = {
    "/etc/garage.toml" = templatefile("${path.module}/garage.toml.tftpl", local.env)
  }
  start_first = false
}
