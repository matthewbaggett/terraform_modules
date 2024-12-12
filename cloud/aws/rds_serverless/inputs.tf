variable "instance_name" {
  type        = string
  description = "The name of the RDS serverless instance"
  default     = "serverless-multitennant"
}
variable "tennants" {
  type = map(object({
    username = string
    password = string
    database = string
  }))
  default = null
}
variable "application" {
  description = "The AWS myApplication to be associated with this cluster"
  type = object({
    arn             = string
    name            = string
    description     = string
    application_tag = map(string)
  })
  default = null
}

variable "engine" {
  type        = string
  description = "The database engine to use"
  default     = "aurora-mysql"
  validation {
    error_message = "Must be either aurora-mysql or aurora-postgresql"
    condition     = contains(["aurora-mysql", "aurora-postgresql"], var.engine)
  }
}
variable "engine_version" {
  type    = string
  default = "13.6"
}

variable "scaling" {
  type = object({
    max_capacity             = optional(number, 0.5)
    min_capacity             = optional(number, 0)
    seconds_until_auto_pause = optional(number, 3600)
  })
  validation {
    error_message = "max_capacity must be greater or equal to min_capacity"
    condition     = var.scaling.max_capacity >= var.scaling.min_capacity
  }
  validation {
    error_message = "min_capacity must be between 0 and 128 in steps of 0.5"
    condition     = var.scaling.min_capacity % 0.5 == 0 && var.scaling.min_capacity >= 0 && var.scaling.min_capacity <= 128
  }
  validation {
    error_message = "max_capacity must be between 0 and 128 in steps of 0.5"
    condition     = var.scaling.max_capacity % 0.5 == 0 && var.scaling.max_capacity >= 0 && var.scaling.max_capacity <= 128
  }
}