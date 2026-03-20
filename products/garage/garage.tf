module "garage" {
  source          = "../../docker/service"
  stack_name      = var.stack_name
  service_name    = var.service_name
  image           = "${var.image}:${var.tag}"
  converge_enable = false
  ports = [
    {
      host         = var.rpc_port
      container    = var.rpc_port
      publish_mode = "host"
      }, {
      host         = var.web_port
      container    = var.web_port
      publish_mode = "host"
      }, {
      host         = var.s3_port
      container    = var.s3_port
      publish_mode = "host"
      }, {
      host         = var.admin_port
      container    = var.admin_port
      publish_mode = "host"
    }
  ]
  networks              = [module.network]
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
