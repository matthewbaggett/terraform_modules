variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
}
variable "service_name" {
  type        = string
  description = "The name of the service to deploy. Will be appended with the stack name."
}
variable "mode" {
  description = "The network mode of the service. If you need both, create two instances."
  type        = string
  default     = "tcp"
  validation {
    error_message = "Mode must be either 'tcp' or 'udp'."
    condition     = var.mode == "tcp" || var.mode == "udp"
  }
}
variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, true)
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
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "target" {
  type = object({
    host = string
    port = number
  })
}
variable "ports" {
  type = list(object({
    host      = optional(number, null)
    container = number
    protocol  = optional(string, "tcp")
  }))
  default = []
}