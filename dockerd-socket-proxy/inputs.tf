variable "docker_socket_proxy_image" {
  default = "ghcr.io/tecnativa/docker-socket-proxy"
}
variable "docker_socket_proxy_version" {
  default = "latest"
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
variable "endpoint" {
  type        = string
  description = "The endpoint to connect to."
}
variable "port" {
  type        = number
  description = "The port to expose on the host."
}
variable "networks" {
  type        = list(string)
  description = "Docker networks to connect the service to."
}