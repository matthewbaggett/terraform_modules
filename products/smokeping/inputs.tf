variable "timezone" {
  type        = string
  description = "The timezone to use for the service."
  default     = "Europe/London"
}
variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number, 80)
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
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}