variable "stack_name" {
  default     = "mitmproxy"
  type        = string
  description = "The name of the stack to create."
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, true)
    ssl              = optional(bool, false)
    rule             = optional(string)
    middlewares      = optional(list(string))
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string))
  })
  description = "Whether to enable traefik for the service."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "domain" {
  type        = string
  description = "The domain to use for the service."
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
}
variable "remote_volumes" {
  type = map(object({
    id     = string
    driver = string
  }))
  default     = {}
  description = "A remote volume is a volume created explicitly and not implicitly by this Service. This is a map of remote volumes to mount into the container. The key is the source, and the value is the target."
}
variable "ports" {
  type = list(object({
    host         = optional(number, null)
    container    = number
    protocol     = optional(string, "tcp")
    publish_mode = optional(string, "ingress")
  }))
  default = []
}
variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "A map of environment variables to set in the container."
}
variable "converge_enable" {
  default     = true
  type        = bool
  description = "Whether to enable the converge configuration."
}