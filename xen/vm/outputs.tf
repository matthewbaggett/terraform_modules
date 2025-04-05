output "ipv4" {
  value = xenorchestra_vm.vm.network[0].ipv4_addresses[0]
}
output "mac_address" {
  value = macaddress.vm.address
}
output "hostname" {
  value = local.hostname
}
output "ssh_identity" {
  value = "${var.user.name}@${xenorchestra_vm.vm.network[0].ipv4_addresses[0]}"
}