resource "xenorchestra_vm" "vm" {
  memory_max       = var.memory_max_gb * 1024 * 1024 * 1024
  cpus             = var.cpus
  cloud_config     = xenorchestra_cloud_config.cloudinit.template
  name_label       = var.hostname
  name_description = var.description
  template         = data.xenorchestra_template.template.id

  # Prefer to run the VM on the primary pool instance
  #affinity_host = data.xenorchestra_pool.pool.master
  network {
    network_id = data.xenorchestra_network.net.id
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "${var.hostname}_imavo"
    size       = var.disk_size_gb * 1024 * 1024 * 1024
  }

  tags = concat(var.tags, ["terraform"])

  timeouts {
    create = "${var.timeout}m"
  }
}

output "ipv4s" {
  value = xenorchestra_vm.vm.network[0].ipv4_addresses
}