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
  type    = list(string)
  default = []
}
variable "ports" {
  type = list(object({
    host      = number
    container = number
  }))
  default     = []
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}