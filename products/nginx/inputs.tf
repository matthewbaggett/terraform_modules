variable "service_name" {
  type    = string
  default = "nginx"
}
variable "configs" {
  type = list(object({
    file = string
    id   = string
    name = string
  }))
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "replicas" {
  type        = number
  default     = 2
  description = "The number of instances to deploy"
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}