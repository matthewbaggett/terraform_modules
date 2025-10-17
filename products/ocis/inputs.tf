variable "placement_constraints" {
  type        = list(string)
  description = "A list of placement constraints to apply to the service."
  default     = []
}
variable "stack_name" {
  type        = string
  description = "Stack Name"
}
variable "image" {
  type        = string
  default     = "owncloud/ocis"
  description = "The docker image to use."
}
variable "tag" {
  type        = string
  description = "Tag of the docker image to use."
  default     = "7"
}
variable "domain" {
  type        = string
  description = "Domain to use e.g 'https://ocis.example.org'."
}
variable "ldap" {
  type = object({
    uri      = string
    insecure = bool
    base_dn  = string
    bind = object({
      dn       = string
      password = string
    })
    admin_user_uuid = optional(string)
    user_base_dn    = string
    group_base_dn   = string
    user_filter     = string
    group_filter    = string
  })
}
variable "s3" {
  type = object({
    endpoint   = string
    region     = string
    access_key = string
    secret_key = string
    bucket     = string
  })
}
variable "log" {
  type = object({
    level = string
  })
  validation {
    error_message = "log.level should be one of 'info', 'debug', 'warning'."
    condition     = contains(["info", "debug", "warning"], var.log.level)
  }
  default = {
    level = "info"
  }
}
variable "port" {
  type        = number
  description = "Port to use for the disk storage service."
  default     = 9200
}