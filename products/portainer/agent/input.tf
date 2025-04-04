variable "portainer" {
  type = object({
    portainer_version = string
    service_name      = string
    network = object({
      name = string
      id   = string
    })
    stack_name = string
  })
}
variable "edge_id" {
  type        = string
  description = "The ID of the edge agent"
  default     = "NOT SET YET"
}
variable "edge_key" {
  type        = string
  description = "The key of the edge agent"
  default     = "NOT SET YET"
}
variable "debug" {
  type        = bool
  description = "Enable debug mode"
  default     = false
}
locals {
  agent_service_name = "${var.portainer.service_name}-agent"
}