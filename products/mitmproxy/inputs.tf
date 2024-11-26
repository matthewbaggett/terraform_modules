variable "stack_name" {
  default     = "mitmproxy"
  type        = string
  description = "The name of the stack to create."
}

variable "networks" {
  type        = list(string)
  default     = []
  description = "A list of network names to attach the service to."
}

variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number, 8081)
  })
  description = "Whether to enable traefik for the service."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
