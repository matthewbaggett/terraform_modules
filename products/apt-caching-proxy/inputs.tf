variable "placement_constraints" {
  type        = list(string)
  default     = []
  description = "Docker Swarm placement constraints"
}
variable "port" {
  type        = number
  description = "The port to expose the apt-caching-proxy on the host."
  default     = 3142
}