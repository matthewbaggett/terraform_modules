variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
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
    port   = optional(number, 80)
    ssl    = optional(bool)
  })
  description = "Whether to enable traefik for the service."
}

variable "email" {
  description = "The email address to use for the pgadmin login"
  type        = string
}