variable "statping_image" {
  #default = "quay.io/statping-ng/statping-ng"
  default = "adamboutcher/statping-ng"
}
variable "statping_version" {
  default = "latest"
}
variable "stack_name" {
  default     = "statping"
  type        = string
  description = "The name of the stack to create."
}
variable "name" {
  type    = string
  default = "statping"
}
variable "description" {
  type    = string
  default = "This is an install of statping"
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}