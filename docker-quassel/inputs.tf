variable "quassel_image" {
  default     = "lscr.io/linuxserver/quassel-core"
  type        = string
  description = "The image to use for the quassel service"
}
variable "quassel_version" {
  default     = "latest"
  type        = string
  description = "The version of the quassel image to use"
}
variable "stack_name" {
  default     = "quassel"
  type        = string
  description = "The name of the stack to create."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}