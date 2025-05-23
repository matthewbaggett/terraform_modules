variable "enable" {
  type        = bool
  description = "Whether to enable the service."
  default     = true
}
variable "debug" {
  type        = bool
  default     = false
  description = "Enable debug mode"
}
variable "debug_path" {
  type        = string
  description = "Path to write debug files to"
  default     = null
}
variable "postgres_image" {
  default     = "postgres"
  type        = string
  description = "The docker image to use for the postgres service."
}
variable "postgres_version" {
  default     = "17"
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
variable "service_name" {
  default     = "postgres"
  type        = string
  description = "The name of the service to create."
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
    host         = optional(number, null)
    container    = number
    protocol     = optional(string, "tcp")
    publish_mode = optional(string, "ingress")
  }))
  default     = []
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
  validation {
    error_message = "Host Ports must be between 1024 and 65535 or null."
    condition     = alltrue([for port in var.ports : port.host == null ? true : (port.host >= 1024 && port.host <= 65535)])
  }
  validation {
    error_message = "Container Ports must be between 1 and 65535."
    condition     = alltrue([for port in var.ports : port.container >= 1 && port.container <= 65535])
  }
  validation {
    error_message = "Protocol must be either 'tcp' or 'udp'."
    condition     = alltrue([for port in var.ports : port.protocol == "tcp" || port.protocol == "udp"])
  }
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "data_persist_path" {
  default     = null
  description = "Path on host machine to persist data. Leaving this blank will provision an ephemeral volume."
  type        = string
}
variable "init_scripts" {
  default     = {}
  description = "A map of init scripts to run on startup. The key is the script name, and the value is the script content."
  type        = map(string)
  validation {
    error_message = "Init scripts must be a map of script names to script content."
    condition     = can(var.init_scripts)
  }
}