variable "command" {
  type        = string
  description = "The command to run in the container."
}
variable "image" {
  type        = string
  description = "The docker image to use for the swarm-exec service."
  default     = "mavenugo/swarm-exec:17.03.0-ce"
}
variable "stack_name" {
  description = "The name of the collective stack"
  type        = string
}
variable "service_name" {
  description = "The name of the service"
  type        = string
}