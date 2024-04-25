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
}
variable "replicas" {
  type        = number
  default     = 2
  description = "The number of instances to deploy"
}
