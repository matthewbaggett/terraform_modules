variable "http2https_image" {
  default     = "articulate/http-to-https"
  type        = string
  description = "The docker image to use for the MemcacheD service."
}
variable "http2https_version" {
  default     = "latest"
  type        = string
  description = "The version of the docker image to use for the MemcacheD service."
}
# Pass-thru variables
variable "stack_name" {
  type = string
}
variable "service_name" {
  default     = "iperf3"
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
    host      = optional(number)
    container = number
    protocol  = optional(string, "tcp")
  }))
  default     = []
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
  validation {
    error_message = "Host Ports must be between 1 and 65535 or null."
    condition     = alltrue([for port in var.ports : port.host == null ? true : (port.host >= 1 && port.host <= 65535)])
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
