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
variable "debug" {
  type        = bool
  description = "Enable debug mode"
  default     = false
}

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
    name        = string
    password    = optional(string, null)
    private_key = optional(string, null)
    public_key  = optional(string, null)
  })
  description = "The user to create in the cloud config."
  default     = null
}
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
variable "startup_scripts" {
  description = "Extra startup scripts to run on the VM during init."
  type        = list(string)
  default     = []
}