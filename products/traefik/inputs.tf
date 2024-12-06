variable "stack_name" {
  default     = "loadbalancer"
  type        = string
  description = "The name of the stack to create."
}

variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "ssl_enable" {
  type        = bool
  default     = true
  description = "Whether to enable SSL & ACME certificate generation."
}
variable "acme_use_staging" {
  type        = bool
  default     = false
  description = "Whether to use the Let's Encrypt staging server."
}
variable "acme_email" {
  description = "The email address to use for the ACME certificate."
  type        = string
}
variable "traefik_service_domain" {
  type    = string
  default = null
}
variable "hello_service_domain" {
  type    = string
  default = null
}
variable "log_level" {
  type        = string
  default     = "INFO"
  description = "The log level to use for traefik."
}
variable "access_log" {
  type        = bool
  default     = false
  description = "Whether to enable access logging."
}
variable "access_log_fields_default_mode" {
  type        = string
  default     = "deny"
  description = "The default mode for access log fields."
}
variable "redirect_to_ssl" {
  type        = bool
  default     = true
  description = "Whether to redirect HTTP to HTTPS."
}
variable "http_port" {
  type        = number
  default     = 80
  description = "The port to listen on for HTTP traffic."
}
variable "https_port" {
  type        = number
  default     = 443
  description = "The port to listen on for HTTPS traffic."
}
variable "dashboard_port" {
  type        = number
  default     = 8080
  description = "The port to listen on for the dashboard."
}

variable "ping_enable" {
  type        = bool
  default     = false
  description = "Whether to enable the ping endpoint."
}
variable "ping_entrypoint" {
  type        = string
  default     = "web"
  description = "The traefik entrypoint to use for the ping endpoint."
}
variable "enable_docker_provider" {
  type        = bool
  default     = true
  description = "Whether to enable the Docker provider."
}
variable "enable_swarm_provider" {
  type        = bool
  default     = true
  description = "Whether to enable the Swarm provider."
}