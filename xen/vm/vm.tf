variable "template" {
  type        = string
  description = "Xen Orchestra template to use for VM creation."
  default     = "Ubuntu Noble Numbat 24.04"
}
variable "network" {
  type        = string
  default     = "Pool-wide network associated with eth0"
  description = "Network to attach to the VM"
}
variable "memory_max_gb" {
  type        = number
  description = "The maximum memory for the VM in gigabytes"
  default     = 2
}
variable "cpus" {
  type        = number
  description = "The number of CPUs for the VM"
  default     = 1
}
variable "tags" {
  type        = list(string)
  description = "Tags to apply to the VM"
  default     = []
}
variable "timeout" {
  type        = number
  description = "Timeout for the VM creation in minutes"
  default     = 5
}
locals {
  network_config = {
    network = {
      version = 1
      config = [{
        type    = "physical"
        name    = "enX0"
        subnets = [{ type = "dhcp" }]
      }]
    }
  }
}
resource "xenorchestra_vm" "vm" {
  memory_max           = var.memory_max_gb * 1024 * 1024 * 1024
  cpus                 = var.cpus
  cloud_config         = xenorchestra_cloud_config.cloudinit.template
  cloud_network_config = yamlencode(local.network_config)
  name_label           = var.name
  name_description     = var.description
  template             = data.xenorchestra_template.template.id
  tags                 = concat(var.tags, ["terraform"])
  wait_for_ip          = true

  network {
    network_id  = data.xenorchestra_network.net.id
    mac_address = macaddress.vm.address
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "${var.name} Boot Volume"
    size       = var.disk_size_gb * 1024 * 1024 * 1024
  }

  timeouts {
    create = "${var.timeout}m"
    delete = "${var.timeout}m"
    update = "${var.timeout}m"
  }

  lifecycle {
    replace_triggered_by = [
      data.xenorchestra_template.template.id,
      data.xenorchestra_network.net.id,
      data.xenorchestra_sr.local_storage.id,
    ]
  }
}
