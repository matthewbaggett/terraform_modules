variable "image" {
  type = string
}
variable "command" {
  type    = list(string)
  default = null
}
variable "one_shot" {
  type        = bool
  default     = false
  description = "Whether to run the service as a one-shot task."
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
}
variable "service_name" {
  type        = string
  description = "The name of the service to deploy. Will be appended with the stack name."
}
variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "A map of environment variables to set in the container."
}
variable "networks" {
  type        = list(string)
  default     = []
  description = "A list of network names to attach the service to."
}
variable "healthcheck" {
  type        = list(string)
  default     = null
  description = "Healthcheck command to run, in the docker style."
}
variable "volumes" {
  type        = map(string)
  default     = {}
  description = "A map of volume names to create and mount. The key is the volume name, and the value is the mount point."
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
}
variable "configs" {
  type = map(object({
    name_prefix = list(string),
    contents    = string,
    path        = string
  }))
  default     = {}
  description = "A map of config names to create and mount. The key is the config name, and the value is the config contents."
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
variable "dns_nameservers" {
  type        = list(string)
  default     = null
  description = "A list of DNS nameservers to use for the service."
}

# Scaling and deployment variables
variable "parallelism" {
  default     = 1
  type        = number
  description = "The number of instances to run."
}
variable "update_waves" {
  default     = 3
  type        = number
  description = "When updating a multi-instance service, the number of waves of updates to run."
}
variable "start_first" {
  default     = true
  type        = bool
  description = "When updating a multi-instance service, whether to start or stop instances first. Start-first allows for a clean handoff, but not every instance is capable of this."
}
variable "global" {
  default     = false
  type        = bool
  description = "Whether to run the service globally (or replicated if false)."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "processor_architecture" {
  default     = "amd64"
  type        = string
  description = "The processor architecture to use for the service."
}
variable "operating_system" {
  default     = "linux"
  type        = string
  description = "The operating system to use for the service. Almost always 'linux'."
}
