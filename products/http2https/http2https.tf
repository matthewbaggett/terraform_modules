module "service" {
  source                = "../../docker/service"
  image                 = "${var.http2https_image}:${var.http2https_version}"
  stack_name            = var.stack_name
  service_name          = var.service_name
  networks              = var.networks
  converge_enable       = false # @todo MB: fix healthcheck and fix this.
  ports                 = var.ports
  placement_constraints = var.placement_constraints
}
