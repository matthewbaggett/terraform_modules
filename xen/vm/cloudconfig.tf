variable "hostname" {
  type        = string
  description = "The hostname of the VM"
}
variable "description" {
  type        = string
  description = "Managed through Terraform."
}
module "cloudinit" {
  source   = "../cloudinit"
  hostname = var.hostname
}
resource "xenorchestra_cloud_config" "cloudinit" {
  name     = "${var.hostname} Cloud Config"
  template = module.cloudinit.user_data
}