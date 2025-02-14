variable "interval_seconds" {
  default = 300
  type    = number
}
variable "stack_name" {
  default     = "dns"
  type        = string
  description = "The name of the stack to create."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "protocol" {
  type = string
}
variable "router" {
  type    = string
  default = "webv4,webv4=ipify-ipv4"
}
variable "domain" {
  type = string
}
variable "onrootdomain" {
  default = false
  type    = bool
}
variable "login" {
  type    = string
  default = null
}
variable "password" {
  type    = string
  default = null
}
variable "apikey" {
  type    = string
  default = null
}
variable "secretapikey" {
  type    = string
  default = null
}