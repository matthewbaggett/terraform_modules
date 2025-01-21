variable "enable" {
  default     = true
  type        = bool
  description = "Whether to enable the service or to merely provision the service."
}
variable "image" {
  type        = string
  description = "The image to deploy/build/tag."
}
variable "build" {
  type = object({
    context    = string
    dockerfile = optional(string, "Dockerfile")
    target     = optional(string, null)
    args       = optional(map(string), {})
    tags       = optional(list(string), [])
  })
  default     = null
  description = "The build configuration for the image."
}
variable "mirror" {
  type        = string
  default     = null
  description = "Whether to mirror the image to the local registry. Value is the mirror location."
}
variable "command" {
  type    = list(string)
  default = null
}
variable "restart_policy" {
  type        = string
  default     = "any"
  description = "The restart policy for the service."
  validation {
    error_message = "Restart policy must be either 'any', 'on-failure', or 'none'."
    condition     = var.restart_policy == "any" || var.restart_policy == "on-failure" || var.restart_policy == "none"
  }
}
variable "restart_delay" {
  type        = string
  default     = "0s"
  description = "The delay before restarting the service."
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
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network objects to attach the service to."
}
variable "healthcheck" {
  type        = list(string)
  default     = null
  description = "Healthcheck command to run, in the docker style."
}
variable "healthcheck_interval" {
  type        = string
  default     = "10s"
  description = "The interval to run the healthcheck."
}
variable "healthcheck_timeout" {
  type        = string
  default     = "3s"
  description = "The timeout for the healthcheck."
}
variable "healthcheck_retries" {
  type        = number
  default     = 0
  description = "The number of retries for the healthcheck."
}
variable "healthcheck_start_period" {
  type        = string
  default     = "0s"
  description = "The start period for the healthcheck."
}
variable "volumes" {
  type        = map(string)
  default     = {}
  description = "A map of internally created volume names to create and mount. The key is the volume name, and the value is the mount point."
}
variable "remote_volumes" {
  type = map(object({
    id     = string
    driver = string
  }))
  default     = {}
  description = "A remote volume is a volume created explicitly and not implicitly by this Service. This is a map of remote volumes to mount into the container. The key is the source, and the value is the target."
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
}
variable "configs" {
  type        = map(string)
  default     = {}
  description = "A map of config files to create. Key being the path to the file, and the value being the content. The config will be created using the truncated file name and a timestamp."
}
variable "remote_configs" {
  type = map(object({
    id   = string
    name = string
  }))
  default     = {}
  description = "A remote config is a config created explicitly and not implicitly by this Service. This is a map of remote configs to mount into the container. The key is the source, and the value is the target."
}
variable "ports" {
  type = list(object({
    host      = optional(number, null)
    container = number
    protocol  = optional(string, "tcp")
  }))
  default     = []
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
  validation {
    error_message = "Host Ports must be between 1 and 65535. Or null."
    # This condition is structured wierd because terraform doesn't have
    # short-circuiting and a variable that is null cannot also be read
    # for the port number validation.
    condition = alltrue([for port in var.ports : port.host == null ? true : (port.host >= 1 && port.host <= 65535)])
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
variable "dns_nameservers" {
  type        = list(string)
  default     = null
  description = "A list of DNS nameservers to use for the service."
}
variable "labels" {
  type        = map(string)
  default     = {}
  description = "A map of labels to apply to the service"
}

# Scaling and deployment variables
variable "parallelism" {
  default     = 1
  type        = number
  description = "The number of instances to run."
}
variable "parallelism_per_node" {
  default     = 0
  type        = number
  description = "The maximum number of instances to run per node. 0 means no limit."
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
variable "converge_enable" {
  default     = true
  type        = bool
  description = "Whether to enable the converge configuration."
}
variable "converge_timeout" {
  default     = "2m"
  type        = string
  description = "The timeout for the service to converge."
}
variable "limit_cpu" {
  default     = null
  type        = number
  description = "The CPU limit for the service."
}
variable "limit_ram_mb" {
  default     = null
  type        = number
  description = "The RAM limit for the service, measured in megabytes."
}
variable "reserved_cpu" {
  default     = null
  type        = number
  description = "The CPU reservation for the service."
}
variable "reserved_ram_mb" {
  default     = null
  type        = number
  description = "The RAM reservation for the service, measured in megabytes."
}