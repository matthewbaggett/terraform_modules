variable "enabled" {
  default     = true
  description = "Whether the port forward should be enabled"
  type        = bool
}
variable "label" {
  description = "The label of the port forward"
  type        = string
}
variable "ip" {
  description = "The target IP address to forward to"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.ip))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}
variable "port" {
  description = "The port to forward"
  type        = number
  default     = null
}
variable "port_from" {
  description = "The port to forward from"
  type        = number
  default     = null
}
variable "port_to" {
  description = "The port to forward to"
  type        = number
  default     = null
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

