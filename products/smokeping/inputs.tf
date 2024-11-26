variable "timezone" {
  type        = string
  description = "The timezone to use for the service."
  default     = "Europe/London"
}
variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number)
  })
  description = "Whether to enable traefik for the service."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
