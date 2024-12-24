variable "authorized_keys" {
  type        = list(string)
  default     = []
  description = "List of SSH public keys to add to the bastion server"
}
variable "port" {
  type        = number
  default     = 2200
  description = "The port to use for the bastion server"
}
variable "motd" {
  type    = string
  default = "Welcome to Bastion!"
}

variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}