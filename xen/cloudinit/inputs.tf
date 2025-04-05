variable "hostname" {
  type = string
  validation {
    error_message = "The hostname must only contain lower case alphanumeric characters, underscores and hyphens"
    condition     = can(regex("^[a-z0-9_-]+$", var.hostname))
  }
}
variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "cluster"
}
variable "advertise_address" {
  description = "The address to advertise for the manager to join the cluster. If null, docker will try to work out what address to use."
  type        = string
  default     = null
}
variable "default_address_pool_cidr" {
  type    = string
  default = "10.255.0.0/24"
}
variable "manager_token" {
  description = "Swarm manager join token"
  type        = string
  default     = null
}
variable "worker_token" {
  description = "Swarm worker join token"
  type        = string
  default     = null
}
variable "manager_address" {
  description = "The address of the manager to join including port. Example: example.com:2377"
  type        = string
  default     = null
}
variable "extra_apt_packages" {
  description = "Extra apt packages to install"
  type        = list(string)
  default     = []
}
variable "extra_docker_labels" {
  description = "Extra docker labels to add to the node"
  type        = list(string)
  default     = []
}
variable "service_account_username" {
  description = "The username of the service account to create"
  type        = string
  default     = "ubuntu"
}
variable "service_account_public_ssh_keys" {
  description = "The public SSH keys to add to the service account"
  type        = list(string)
  default     = []
}
variable "service_account_password" {
  description = "The password of the service account to create"
  type        = string
  default     = null
}
variable "startup_scripts" {
  description = "Extra startup scripts to run on the VM during init."
  type        = list(string)
  default     = []
}