variable "pool_name" {
  type        = string
  description = "The name of the pool"
}
variable "template" {
  type        = string
  description = "Xen Orchestra template to use for VM creation."
  default     = "Debian Bookworm 12"
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
  default     = 2
}
variable "storage_name" {
  type        = string
  description = "Name for the storage volume to use."
  default     = "Local storage"
}
variable "disk_size_gb" {
  type        = number
  description = "The size of the disk for the VM in gigabytes"
  default     = 16
}