variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "stack_name" {
  type        = string
  default     = "docker-registry"
  description = "The name of the stack"
}
variable "registry_name" {
  type        = string
  default     = "Docker Registry"
  description = "The name of the registry"
}
variable "registry_users" {
  type = list(object({
    username = string
    password = optional(string)
  }))
  description = "A list of users to create in the registry"
}
variable "enable_delete" {
  type        = bool
  default     = false
  description = "Enable the delete feature in the registry"
}
variable "s3" {
  type = object({
    accesskey      = string
    secretkey      = string
    region         = string
    regionendpoint = optional(string, null)
    forcepathstyle = optional(bool, false)
    bucket         = string
  })
  description = "S3 configuration for the registry."
}
variable "domain" {
  type        = string
  description = "The domain for the registry"
}
variable "cors_domains" {
  type        = list(string)
  description = "A list of domains to allow CORS requests from"
  default     = []
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  description = "A list of networks to attach the service to"
  default     = []
}
variable "traefik" {
  default = null
  type = object({
    domain  = string
    port    = optional(number, 80)
    non-ssl = optional(bool, true)
    ssl     = optional(bool, false)
    rule    = optional(string)
  })
  description = "Whether to enable traefik for the service."
}
variable "ports" {
  type = list(object({
    host         = optional(number, null)
    container    = number
    protocol     = optional(string, "tcp")
    publish_mode = optional(string, "ingress")
  }))
  default     = [{ container = 5000 }]
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
}
variable "dns_nameservers" {
  type        = list(string)
  default     = null
  description = "A list of DNS nameservers to use for the service."
}
