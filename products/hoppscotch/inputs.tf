variable "enable" {
  default     = true
  type        = bool
  description = "Whether to enable the service or to merely provision the service."
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
  default     = "hoppscotch"
}
variable "publish_mode" {
  type        = string
  description = "The publish mode for the service."
  default     = "ingress"
}
variable "data_persist_path" {
  type        = string
  description = "The path to persist data to."
  default     = null
}
variable "placement_constraints" {
  description = "Placement constraints for the service."
  type = object({
    default    = list(string)
    persistent = list(string)
  })
  default = {
    default    = []
    persistent = []
  }
}
variable "domains" {
  type = object({
    frontend = string
    backend  = string
    admin    = string
  })
  description = "The domains to use for the service."
  default = {
    frontend = "hoppscotch.example.org"
    backend  = "backend.example.org"
    admin    = "admin.example.org"
  }
}

variable "smtp" {
  type = object({
    host     = string
    port     = number
    secure   = bool
    username = string
    password = string
  })
  default = null
}
variable "networks" {
  type        = list(string)
  description = "The networks to use for the service."
  default     = []
}