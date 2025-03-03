variable "memcached_image" {
  default     = "memcached"
  type        = string
  description = "The docker image to use for the MemcacheD service."
}
variable "memcached_version" {
  default     = "1"
  type        = string
  description = "The version of the docker image to use for the MemcacheD service."
}
variable "connection_limit" {
  default     = 1024
  type        = number
  description = "The maximum number of connections to allow."
}
variable "memory_limit_mb" {
  default     = 128
  type        = number
  description = "The maximum amount of memory to use in megabytes."
}
variable "threads" {
  default     = 8
  type        = number
  description = "The number of threads to use."
}
# Pass-thru variables
variable "stack_name" {
  type = string
}
variable "service_name" {
  default     = "memcached"
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