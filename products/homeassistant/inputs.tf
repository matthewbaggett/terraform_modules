variable "stack_name" {
  default     = "homeassistant"
  type        = string
  description = "The name of the stack to create."
}

variable "default_image" {
  default     = "ghcr.io/home-assistant/home-assistant:stable"
  type        = string
  description = "The image to use for the homeassistant service"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "A map of environment variables to set in the container."
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "traefik" {

}