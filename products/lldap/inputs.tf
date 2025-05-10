#       ______
#      / ____/___  ____ ___  ____ ___  ____  ____
#     / /   / __ \/ __ `__ \/ __ `__ \/ __ \/ __ \
#    / /___/ /_/ / / / / / / / / / / / /_/ / / / /
#    \____/\____/_/ /_/ /_/_/ /_/ /_/\____/_/ /_/
#
variable "enable" {
  default     = true
  type        = bool
  description = "Whether to enable the service or to merely provision the service."
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
  default     = "auth"
}
variable "publish_mode" {
  type        = string
  description = "The publish mode for the service."
  default     = "ingress"
}
variable "placement_constraints" {
  description = "Placement constraints for the service."
  type        = list(string)
  default     = []
}
variable "domain" {
  type        = string
  description = "The domain to use for the service."
  default     = null
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network objects to attach the service to."
}

#       __    __    ____  ___    ____
#      / /   / /   / __ \/   |  / __ \
#     / /   / /   / / / / /| | / /_/ /
#    / /___/ /___/ /_/ / ___ |/ ____/
#   /_____/_____/_____/_/  |_/_/
variable "timezone" {
  type        = string
  description = "The timezone to set in the container."
  default     = "Europe/Amsterdam"
}

variable "base_dn" {
  type        = string
  description = "The base DN for the LDAP server."
  default     = "dc=example,dc=com"
}
variable "admin_user_password" {
  type        = string
  description = "The password for the admin user."
  default     = null
}
variable "enable_password_reset" {
  type        = bool
  description = "Whether to enable the password reset feature."
  default     = false
}
variable "smtp_enable" {
  type        = bool
  description = "Whether to enable the SMTP server."
  default     = false
}
variable "smtp_server" {
  type        = string
  description = "The SMTP server to use."
  default     = null
}
variable "smtp_port" {
  type        = number
  description = "The SMTP server port to use."
  default     = null
}
variable "smtp_encryption" {
  type        = string
  description = "The SMTP server encryption to use. Must be one of: NONE, TLS, STARTTLS"
  default     = "NONE"
  validation {
    condition     = contains(["NONE", "TLS", "STARTTLS"], var.smtp_encryption)
    error_message = "The SMTP server encryption must be one of: NONE, TLS, STARTTLS"
  }
}
variable "smtp_user" {
  type        = string
  description = "The SMTP server user to use."
  default     = null
}
variable "smtp_password" {
  type        = string
  description = "The SMTP server password to use."
  default     = null
}
variable "smtp_from" {
  type        = string
  description = "The SMTP server from address to use."
  default     = null
}

#        ____             __
#       / __ \____  _____/ /_____ _________  _____
#      / /_/ / __ \/ ___/ __/ __ `/ ___/ _ \/ ___/
#     / ____/ /_/ (__  ) /_/ /_/ / /  /  __(__  )
#    /_/    \____/____/\__/\__, /_/   \___/____/
#                         /____/
variable "postgres_ports" {
  type = list(object({
    host         = optional(number, null)
    container    = number
    protocol     = optional(string, "tcp")
    publish_mode = optional(string, "ingress")
  }))
  default     = []
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
  validation {
    error_message = "Host Ports must be between 1024 and 65535 or null."
    condition     = alltrue([for port in var.postgres_ports : port.host == null ? true : (port.host >= 1024 && port.host <= 65535)])
  }
  validation {
    error_message = "Container Ports must be between 1 and 65535."
    condition     = alltrue([for port in var.postgres_ports : port.container >= 1 && port.container <= 65535])
  }
  validation {
    error_message = "Protocol must be either 'tcp' or 'udp'."
    condition     = alltrue([for port in var.postgres_ports : port.protocol == "tcp" || port.protocol == "udp"])
  }
}
variable "postgres_data_persist_path" {
  type    = string
  default = null
}
variable "postgres_placement_constraints" {
  description = "Placement constraints for the service."
  type        = list(string)
  default     = []
}