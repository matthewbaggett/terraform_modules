variable "stack_name" {
  default     = "loadbalancer"
  type        = string
  description = "The name of the stack to create."
}
variable "traefik_image" {
  default     = "traefik:v3.2"
  type        = string
  description = "The image to use for the traefik service"
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "traefik_instance_count" {
  default     = null
  type        = number
  description = "The number of traefik instances to run. If set to null, the service will GLOBAL and run on every node with appropriate placement constraints."
}
variable "hello_instance_count" {
  default     = null
  type        = number
  description = "The number of hello world test instances to run. If set to null, the service will GLOBAL and run on every node with appropriate placement constraints."
}
variable "docker_socket_instance_count" {
  default     = null
  type        = number
  description = "The number of docker socket instances to run. If set to null, the service will GLOBAL and run on every node with appropriate placement constraints."
}
variable "enable_ssl" {
  type        = bool
  default     = true
  description = "Whether to enable SSL & ACME certificate generation."
}
variable "enable_non_ssl" {
  type        = bool
  default     = true
  description = "Whether to enable non-SSL."
}
variable "enable_udp" {
  type        = bool
  default     = false
  description = "Whether to enable UDP."
}
variable "udp_entrypoints" {
  type        = map(list(number))
  default     = {}
  description = "Defined entrypoints to use for UDP traffic."
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
variable "traefik_dashboard_service_domain" {
  type    = string
  default = null
}
variable "hello_service_domain" {
  type    = string
  default = null
}
variable "traefik_dashboard_service_enable_basic_auth" {
  type        = bool
  default     = false
  description = "Whether to enable basic auth for the traefik dashboard."
}
variable "hello_service_enable_basic_auth" {
  type        = bool
  default     = false
  description = "Whether to enable basic auth for the hello service."
}
variable "log_level" {
  type        = string
  default     = "WARN"
  description = "The log level to use for traefik."
  validation {
    error_message = "Must be one of TRACE, DEBUG, INFO, WARN, ERROR, FATAL, and PANIC."
    condition     = can(regex("^(TRACE|DEBUG|INFO|WARN|ERROR|FATAL|PANIC)$", var.log_level))
  }
}
variable "access_log" {
  type        = bool
  default     = false
  description = "Whether to enable access logging."
}
variable "access_log_format" {
  type        = string
  default     = "json"
  description = "The format to use for access logs."
}
variable "access_log_fields_default_mode" {
  type        = string
  default     = "keep"
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
variable "publish_mode" {
  type        = string
  default     = "ingress"
  description = "The publish mode for the service. Can be either ingress or host."
  validation {
    error_message = "Publish mode must be either 'ingress' or 'host'."
    condition     = can(regex("^(ingress|host)$", var.publish_mode))
  }
}

variable "enable_ping" {
  type        = bool
  default     = true
  description = "Whether to enable the ping endpoint."
}
variable "ping_entrypoint" {
  type        = string
  default     = "web"
  description = "The traefik entrypoint to use for the ping endpoint."
}
variable "enable_docker_provider" {
  type        = bool
  default     = false
  description = "Whether to enable the Docker provider."
}
variable "enable_swarm_provider" {
  type        = bool
  default     = true
  description = "Whether to enable the Swarm provider."
}
variable "enable_stats_collection" {
  type        = bool
  default     = true
  description = "Whether to enable stats collection."
}
variable "api_insecure" {
  type        = bool
  default     = false
  description = "Whether to enable the insecure API. Implicitly turned on by enable_dashboard."
}
variable "api_debug" {
  type        = bool
  default     = false
  description = "Whether to enable the debug API."
}
variable "enable_dashboard" {
  type        = bool
  default     = true
  description = "Whether to enable the dashboard."
}
variable "enable_port_reuse" {
  type        = bool
  default     = true
  description = "Whether to enable port reuse. This is a niche traefik feature that might create issues."
}
variable "extra_networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "Additional networks to attach to the traefik service."
}