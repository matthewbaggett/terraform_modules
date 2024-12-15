variable "statping_image" {
  #default = "quay.io/statping-ng/statping-ng"
  default     = "adamboutcher/statping-ng"
  type        = string
  description = "The image to use for the statping service"
}
variable "statping_version" {
  default     = "latest"
  type        = string
  description = "The version of the statping image to use"
}
variable "stack_name" {
  default     = "statping"
  type        = string
  description = "The name of the stack to create."
}
variable "name" {
  type    = string
  default = "statping"
}
variable "description" {
  type    = string
  default = "This is an install of statping"
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "dns_nameservers" {
  type        = list(string)
  default     = []
  description = "A list of DNS servers to use for the service."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "extra_environment_variables" {
  type        = map(string)
  default     = {}
  description = "Extra environment variables to pass to the service."
}
variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number)
    ssl    = optional(bool, false)
    rule   = optional(string)
  })
  description = "Whether to enable traefik for the service."
}