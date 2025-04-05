output "ipv4" {
  value = one(xenorchestra_vm.vm.network[0].ipv4_addresses)
}
output "mac_address" {
  value = macaddress.vm.address
}
output "hostname" {
  value = local.hostname
}
output "ssh_identity" {
  value = "${var.user.name}@${one(xenorchestra_vm.vm.network[0].ipv4_addresses)}"
}