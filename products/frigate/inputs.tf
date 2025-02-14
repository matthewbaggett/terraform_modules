variable "enable" {
  type        = bool
  description = "Whether to enable the service or merely provision it."
  default     = true
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
}
variable "shm_size_mb" {
  default     = 256
  type        = number
  description = "The size of the shared memory segment in MB"
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "frigate_rtsp_password" {
  type        = string
  description = "The password to use for the RTSP streams"
  default     = ""
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
}
variable "ports" {
  type = list(object({
    host      = number
    container = number
    protocol  = optional(string, "tcp")
  }))
  default = [
    {
      container = 5000
      host      = 5000
      protocol  = "tcp"
    },
    {
      container = 1935
      host      = 1935
      protocol  = "tcp"
    },
    {
      container = 8554
      host      = 8554
      protocol  = "tcp"
    },
    {
      container = 8555
      host      = 8555
      protocol  = "tcp"
    },
    {
      container = 8555
      host      = 8555
      protocol  = "udp"
    }
  ]
}

variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, false)
    ssl              = optional(bool, false)
    rule             = optional(string)
    middlewares      = optional(list(string), [])
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string), [])
    headers          = optional(map(string), {})
    udp_entrypoints  = optional(list(string), []) # List of UDP entrypoints
  })
  description = "Whether to enable traefik for the service."
}
variable "labels" {
  type        = map(string)
  default     = {}
  description = "A map of labels to apply to the service"
}
variable "placement_constraints" {
  type        = list(string)
  default     = []
  description = "Docker Swarm placement constraints"
}