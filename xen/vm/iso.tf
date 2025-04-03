variable "iso" {
  type        = string
  description = "The name of the ISO to attach to the VM."
  default     = "ubuntu-24.04.2-live-server-amd64.iso"
}
variable "guest_tools_iso_name" {
  type        = string
  description = "The name of the guest tools ISO to attach to the VM."
  default     = "guest-tools.iso"
}
data "xenorchestra_vdi" "iso" {
  pool_id    = data.xenorchestra_pool.pool.id
  name_label = var.iso
}
data "xenorchestra_vdi" "guest_tools" {
  pool_id    = data.xenorchestra_pool.pool.id
  name_label = var.guest_tools_iso_name
}