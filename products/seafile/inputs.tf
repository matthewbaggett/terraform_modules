variable "enable" {
  type        = bool
  description = "Whether to enable the service."
  default     = true
}
variable "seafile_version" {
  type        = string
  default     = "12.0-latest"
  description = "The version of the docker image to use for the Seafile service."
}
variable "domain" {
  type        = string
  description = "The domain to use for the traefik configuration."
}
# Pass-thru variables
variable "stack_name" {
  type    = string
  default = "seafile"
}
variable "service_name" {
  default     = "seafile"
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
  default = [
    { container = 80 },
  ]
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
}
variable "mysql_ports" {
  type = list(object({
    host         = optional(number, null)
    container    = number
    protocol     = optional(string, "tcp")
    publish_mode = optional(string, "ingress")
  }))
  default = [
    { container = 3306 },
  ]
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
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
