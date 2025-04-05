locals {
  hostname = var.hostname != null ? var.hostname : lower(replace(var.name, " ", "-"))
}
module "cloudinit" {
  source                          = "../cloudinit"
  hostname                        = local.hostname
  service_account_username        = var.user.name
  service_account_password        = var.user.password
  service_account_public_ssh_keys = var.user.ssh_keys
  startup_scripts                  = var.startup_scripts
}
resource "xenorchestra_cloud_config" "cloudinit" {
  name     = "${var.name} Cloud Config"
  template = module.cloudinit.user_data_raw
}