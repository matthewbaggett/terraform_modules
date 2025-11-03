module "ui" {
  source          = "../../docker/service"
  stack_name      = var.stack_name
  service_name    = "${var.service_name}-ui"
  image           = "${var.ui_image}:${var.ui_tag}"
  converge_enable = false
  ports = [
    {
      host      = var.ui_port
      container = var.ui_port
    }
  ]
  networks = [module.network]
  placement_constraints = var.placement_constraints
  environment_variables = {
    API_BASE_URL = "http://${module.garage.service_name}:${var.admin_port}"
    S3_ENDPOINT_URL = "http://${module.garage.service_name}:${var.s3_port}"
  }
  configs = {
    "/etc/garage.toml" = templatefile("${path.module}/garage.toml.tftpl", local.env)
  }
}
