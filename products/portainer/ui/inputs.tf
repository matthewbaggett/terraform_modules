variable "stack_name" {
  default     = "loadbalancer"
  type        = string
  description = "The name of the stack to create."
}
variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number, 9000)
  })
  description = "Whether to enable traefik for the service."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}

variable "portainer_version" {
  default     = "sts"
  type        = string
  description = "The version of the portainer image to use."
}
variable "portainer_logo" {
  default     = null
  type        = string
  description = "The URL of the logo to use for the portainer service."
}
variable "should_mount_local_docker_socket" {
  type    = bool
  default = false
}