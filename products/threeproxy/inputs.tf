variable "threeproxy_image" {
  type        = string
  description = "The image to use for the 3proxy service."
  default     = "ghcr.io/tarampampam/3proxy"
}
variable "threeproxy_version" {
  type        = string
  description = "The version of the 3proxy image to use."
  default     = "latest"
}
variable "stack_name" {
  default     = "proxy"
  type        = string
  description = "The name of the stack to create."
}
variable "service_name" {
  default     = "3proxy"
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
variable "socks_proxy_port" {
  type        = number
  description = "The port to expose on the host."
}
variable "http_proxy_port" {
  type        = number
  description = "The port to expose on the host."
}