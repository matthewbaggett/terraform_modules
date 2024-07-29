variable "postgres_image" {
  default     = "postgres"
  type        = string
  description = "The docker image to use for the postgres service."
}
variable "postgres_version" {
  default     = "latest"
  type        = string
  description = "The version of the docker image to use for the postgres service."
}
variable "username" {
  default     = null
  type        = string
  description = "The username for the database. If none is provided, a random username will be generated."
}
variable "password" {
  default     = null
  type        = string
  description = "The password for the database. If none is provided, a random password will be generated."
}
variable "database" {
  default     = null
  type        = string
  description = "The name of the database. If none is provided, a random name will be generated."
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
  type        = map(number)
  default     = {}
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}