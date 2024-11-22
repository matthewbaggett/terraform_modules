variable "pgbackweb_image" {
  default     = "eduardolat/pgbackweb"
  type        = string
  description = "The image to use for the pgbackweb service"
}
variable "pgbackweb_version" {
  default     = "latest"
  type        = string
  description = "The version of the pgbackweb image to use"
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