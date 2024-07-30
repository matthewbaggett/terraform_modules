variable "pgbackweb_image" {
  default = "eduardolat/pgbackweb"
}
variable "pgbackweb_version" {
  default = "latest"
}
variable "stack_name" {
  default     = "backup"
  type        = string
  description = "The name of the stack to create."
}
variable "service_name" {
  default     = "pgbackweb"
  type        = string
  description = "The name of the service to create."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "networks" {
  type    = list(string)
  default = []
}