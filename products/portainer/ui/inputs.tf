variable "stack_name" {
  default     = "portainer"
  type        = string
  description = "The name of the stack to create."
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number)
    ssl    = optional(bool, false)
    rule   = optional(string)
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