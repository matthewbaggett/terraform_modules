variable "redis_image" {
  default     = "ghcr.io/benzine-framework/redis"
  type        = string
  description = "The docker image to use for the redis service."
}
variable "redis_version" {
  default     = "7"
  type        = string
  description = "The version of the docker image to use for the redis service."
}

variable "auth" {
  default     = null
  type        = string
  description = "The password for the database. If none is provided, a random password will be generated."
}

# Pass-thru variables
variable "stack_name" {
  type = string
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "ports" {
  type = list(object({
    host      = number
    container = number
    protocol  = optional(string, "tcp")
  }))
  default     = []
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
  validation {
    error_message = "Host Ports must be between 1024 and 65535."
    condition     = alltrue([for port in var.ports : port.host >= 1024 && port.host <= 65535])
  }
  validation {
    error_message = "Container Ports must be between 1 and 65535."
    condition     = alltrue([for port in var.ports : port.container >= 1 && port.container <= 65535])
  }
  validation {
    error_message = "protocol must be either 'tcp' or 'udp'."
    condition     = alltrue([for port in var.ports : port.protocol == "tcp" || port.protocol == "udp"])
  }
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}