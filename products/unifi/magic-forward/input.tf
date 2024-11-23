variable "enabled" {
  default     = true
  description = "Whether the port forward should be enabled"
  type        = bool
}
variable "label" {
  description = "The label of the port forward"
  type        = string
}
variable "docker_service" {
  description = "The Docker Service to forward to"
  type = object({
    name = string
    endpoint_spec = list(object({
      ports = list(object({
        target_port    = number
        published_port = number
        protocol       = string
        publish_mode   = string
      }))
    }))
  })
}
variable "target" {
  description = "The Target Host to forward traffic to"
  type = object({
    mac              = string
    name             = string
    fixed_ip         = string
    local_dns_record = optional(string)
    dev_id_override  = optional(string)
  })
}
variable "protocol" {
  default     = "tcp"
  description = "The protocol to use for the port forward"
  type        = string
  validation {
    condition     = var.protocol == "tcp" || var.protocol == "udp" || var.protocol == "any"
    error_message = "Protocol must be either tcp or udp or any!"
  }
}

variable "port" {
  description = "Override the detected port to forward"
  type        = number
  default     = null
}