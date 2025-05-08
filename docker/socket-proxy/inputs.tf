variable "docker_socket_proxy_image" {
  default     = "ghcr.io/tecnativa/docker-socket-proxy"
  type        = string
  description = "The docker image to use for the docker-socket-proxy service."
}
variable "docker_socket_proxy_version" {
  default     = "0.3"
  type        = string
  description = "The version of the docker image to use for the docker-socket-proxy service."
}
variable "stack_name" {
  default     = "proxy"
  type        = string
  description = "The name of the stack to create."
}
variable "service_name" {
  default     = "docker-socket"
  type        = string
  description = "The name of the service to create."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "global" {
  default     = false
  type        = bool
  description = "Whether to run the service globally (or replicated if false)."
}
variable "parallelism" {
  default     = 1
  type        = number
  description = "The number of instances to run."
}

variable "enable_swarm" {
  type    = bool
  default = true
}
variable "enable_services" {
  type    = bool
  default = true
}
variable "enable_containers" {
  type    = bool
  default = true
}
variable "enable_tasks" {
  type    = bool
  default = true
}
variable "enable_nodes" {
  type    = bool
  default = true
}
variable "enable_networks" {
  type    = bool
  default = true
}
variable "enable_auth" {
  type    = bool
  default = false
}
variable "enable_secrets" {
  type    = bool
  default = false
}
variable "enable_write" {
  type    = bool
  default = false
}
variable "enable_build" {
  type    = bool
  default = false
}
variable "enable_commit" {
  type    = bool
  default = false
}
variable "enable_configs" {
  type    = bool
  default = false
}
variable "enable_distribution" {
  type    = bool
  default = false
}
variable "enable_exec" {
  type    = bool
  default = false
}
variable "enable_grpc" {
  type    = bool
  default = false
}
variable "enable_images" {
  type    = bool
  default = false
}
variable "enable_info" {
  type    = bool
  default = false
}
variable "enable_plugins" {
  type    = bool
  default = false
}
variable "enable_session" {
  type    = bool
  default = false
}
variable "enable_system" {
  type    = bool
  default = false
}
variable "enable_volumes" {
  type    = bool
  default = false
}
variable "enable_all" {
  type    = bool
  default = false
}
