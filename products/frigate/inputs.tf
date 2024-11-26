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
  type        = list(string)
  default     = []
  description = "A list of network names to attach the service to."
}
variable "frigate_rtsp_password" {
  type        = string
  description = "The password to use for the RTSP streams"
  default     = ""
}
variable "devices" {
  type = list(object({
    host_path      = string
    container_path = string
    permissions    = optional(string, "rwm")
  }))
  description = "The devices to mount into the container"
}
variable "volumes" {
  type        = map(string)
  default     = {}
  description = "A map of volume names to create and mount. The key is the volume name, and the value is the mount point."
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
    domain = string
    port   = optional(number, 5000)
  })
  description = "Whether to enable traefik for the service."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A map of labels to apply to the service"
}
