// Inputs
variable "name" {
  type        = string
  description = "The name of the VM"
}
variable "hostname" {
  type        = string
  description = "Override the hostname in the cloud config."
  default     = null
}
variable "description" {
  type        = string
  description = "Managed through Terraform."
}
variable "user" {
  type = object({
    name     = string
    password = optional(string, null)
    ssh_keys = optional(list(string), [])
  })
  description = "The user to create in the cloud config."
  default = {
    name     = "ubuntu"
    password = null
    ssh_keys = []
  }
}

// Locals
locals {
  hostname = var.hostname != null ? var.hostname : lower(replace(var.name, " ", "-"))
}

// Cloudinit generation
module "cloudinit" {
  source                          = "../cloudinit"
  hostname                        = local.hostname
  service_account_username        = var.user.name
  service_account_password        = var.user.password
  service_account_public_ssh_keys = var.user.ssh_keys
}
resource "xenorchestra_cloud_config" "cloudinit" {
  name     = "${var.name} Cloud Config"
  template = module.cloudinit.user_data_raw
}