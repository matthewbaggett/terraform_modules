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
variable "publish_mode" {
  type        = string
  description = "The publish mode for the port. Can be either 'ingress' or 'host'."
  default     = "ingress"
  validation {
    condition     = contains(["ingress", "host"], var.publish_mode)
    error_message = "Publish mode must be either 'ingress' or 'host'."
  }
}
variable "data_persist_path" {
  default     = null
  description = "Path on host machine to persist data. Leaving this blank will provision an ephemeral volume."
  type        = string
}
variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, false)
    ssl              = optional(bool, false)
    rule             = optional(string)
    middlewares      = optional(list(string), [])
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string), [])
    headers          = optional(map(string), {})
    udp_entrypoints  = optional(list(string), []) # List of UDP entrypoints
  })
  description = "Whether to enable traefik for the service."
}