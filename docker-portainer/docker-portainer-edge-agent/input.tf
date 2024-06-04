variable "docker" {
  type = object({
    name_agent = string
    stack_name = optional(string)
  })
}
variable "portainer" {
  type = object({
    version = string
  })
}
variable "edge_id" {
  type        = string
  description = "The ID of the edge agent"
  default     = null
}
variable "edge_key" {
  type        = string
  description = "The key of the edge agent"
  default     = null
}
variable "debug" {
  type        = bool
  description = "Enable debug mode"
  default     = false
}
