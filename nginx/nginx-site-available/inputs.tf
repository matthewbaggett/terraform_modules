variable "hostname" {
  type        = string
  description = "The hostname of the server"
}
variable "service_name" {
  type        = string
  description = "The name of the service"
}
variable "upstream_host" {
  type        = string
  description = "The host uri of the upstream server"
}
variable "certificate" {
  type = object({
    private_key_pem = string
    certificate_pem = string
    issuer_pem      = string
  })
  default = null
}
variable "basic_auth" {
  type = object({
    username = string
    password = string
  })
  default = null
}
variable "allow_non_ssl" {
  type    = bool
  default = false
}
variable "redirect_non_ssl" {
  type    = bool
  default = true
}
variable "timeout_seconds" {
  type    = number
  default = 10
}
variable "http_port" {
  type    = number
  default = 80
}
variable "https_port" {
  type    = number
  default = 443
}
variable "host_override" {
  type    = string
  default = null
}
variable "config_prefix" {
  type    = string
  default = "nginx"
}

variable "extra_upstreams" {
  type = list(object({
    name    = string
    servers = list(string)
  }))
  default = []
}
variable "extra_config" {
  type    = string
  default = ""
}
variable "extra_locations" {
  type    = string
  default = ""
}
