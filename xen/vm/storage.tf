variable "storage" {
  type = object({
    iso = string
    vm  = string
  })
  description = "Names for the storage volume to use."
  default = {
    iso = "ISOs"
    vm  = "Local storage"
  }
}
variable "disk_size_gb" {
  type        = number
  description = "The size of the disk for the VM in gigabytes"
  default     = 16
}
data "xenorchestra_sr" "local_storage" {
  name_label = var.storage.vm
}
data "xenorchestra_sr" "isos" {
  name_label = var.storage.iso
}