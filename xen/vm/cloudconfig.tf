locals {
  hostname = (
    var.hostname != null
    ? var.hostname
    : lower(
      replace(
        replace(
          var.name,
          "/[^A-z0-9- ]/", ""
        ),
        " ", "-"
      )
    )
  )
}
module "cloudinit" {
  source                          = "../cloudinit"
  hostname                        = local.hostname
  service_account_username        = var.user.name
  service_account_password        = var.user.password
  service_account_public_ssh_keys = [var.user.public_key]
  startup_scripts                 = var.startup_scripts
  manager_address                 = var.docker.manager_endpoint
  worker_token                    = var.docker.worker_token
}
resource "xenorchestra_cloud_config" "cloudinit" {
  name     = "${var.name} Cloud Config"
  template = module.cloudinit.user_data_raw
}