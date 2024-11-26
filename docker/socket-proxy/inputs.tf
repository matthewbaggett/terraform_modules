variable "docker_socket_proxy_image" {
  default     = "ghcr.io/tecnativa/docker-socket-proxy"
  type        = string
  description = "The docker image to use for the docker-socket-proxy service."
}
variable "docker_socket_proxy_version" {
  default     = "latest"
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

