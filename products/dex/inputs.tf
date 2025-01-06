variable "stack_name" {
  default     = "dex"
  type        = string
  description = "The name of the stack to create."
}
variable "users" {
  type = list(object({
    username = string
    email    = string
  }))
  default = []
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker placement constraints"
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
