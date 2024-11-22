variable "docker" {
  type = object({
    name       = string
    stack_name = optional(string)
    networks = list(object({
      name = string
      id   = string
    }))
  })
}
variable "portainer" {
  type = object({
    version = string
    logo    = optional(string)
  })
}
