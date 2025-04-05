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

  network {
    network_id  = data.xenorchestra_network.net.id
    mac_address = macaddress.vm.address
    expected_ip_cidr = "0.0.0.0/0"
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
      random_pet.pet_name.id,
      data.xenorchestra_template.template.id,
      data.xenorchestra_network.net.id,
      data.xenorchestra_sr.local_storage.id,
    ]
  }
}
resource "null_resource" "post_startup" {
  depends_on = [xenorchestra_vm.vm]
  connection {
    host = xenorchestra_vm.vm.ipv4_addresses
    type = "ssh"
    user = var.user.name
    password = var.user.password
    private_key = one(var.user.ssh_keys)
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'Post-setup SSH: Connected! That means we are waiting for cloud-init to complete.'",
      "while ! sudo grep -q 'Cloud-init is complete!' /var/log/cloud-init-output.log; do sleep 1; done",
      "echo 'Post-setup SSH: Cloud-init is complete!'",
    ]
  }
}
variable "docker" {
  type = object({
    enable     = optional(bool, false)
    is_manager = optional(bool, false)
  })
  description = "Configure Docker on the VM."
  default     = {
    enable     = false
    is_manager = false
  }
}
resource "null_resource" "tokens" {
  depends_on = [xenorchestra_vm.vm]
  count = var.docker.enable && var.docker.is_manager ? 1 : 0
  connection {
    host = xenorchestra_vm.vm.ipv4_addresses
    type = "ssh"
    user = var.user.name
    password = var.user.password
    private_key = one(var.user.ssh_keys)
  }
  provisioner "remote-exec" {
    inline = [
      # Generate the worker and manager tokens
      "echo 'Post-setup SSH: Generating tokens'",
      "sudo mkdir /swarm",
      "docker swarm join-token -q manager | sudo tee /swarm/manager_token",
      "docker swarm join-token -q worker | sudo tee /swarm/worker_token",
      "echo 'Post-setup SSH: Tokens are ready!'"
    ]
  }
}
data "remote_file" "tokens" {
  depends_on = [xenorchestra_vm.vm, null_resource.tokens]
  conn {
    host = xenorchestra_vm.vm.ipv4_addresses
    user = var.user.name
    private_key = one(var.user.ssh_keys)
    sudo        = true
  }
  for_each   = toset(var.docker.enable && var.docker.is_manager ? ["worker", "manager"]:[])
  path       = "/swarm/${each.key}_token"
}

locals {
  tokens = {
    manager = nonsensitive(trimspace(data.remote_file.tokens["manager"].content)),
    worker  = nonsensitive(trimspace(data.remote_file.tokens["worker"].content)),
  }
}

output "docker" {
  value = {
    enable     = var.docker.enable
    manager_endpoint = var.docker.is_manager ? "${xenorchestra_vm.vm.ipv4_addresses}:2377" : null
    worker_token = local.tokens.worker
    manager_token = local.tokens.manager
  }
}
