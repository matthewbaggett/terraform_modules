variable "quassel_image" {
  default = "lscr.io/linuxserver/quassel-core"
}
variable "quassel_version" {
  default = "latest"
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