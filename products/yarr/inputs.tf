variable "stack_name" {
  description = "The name of the stack"
  type        = string
  default     = "yarr"
}
variable "bind_paths" {
  description = "The paths to the service"
  type = object({
    media = string
    books = string
  })
}
variable "placement_constraints" {
  description = "Docker Swarm placement constraints"
  type        = list(string)
  default     = []
}
variable "traefik" {
  default = null
  type = object({
    domain  = string
    port    = optional(number)
    non-ssl = optional(bool, true)
    ssl     = optional(bool, false)
    rule    = optional(string)
    network = optional(object({
      name = string
      id   = string
    }))
  })
  description = "Whether to enable traefik for the service."
}