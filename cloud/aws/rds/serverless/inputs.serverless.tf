variable "scaling" {
  type = object({
    max_capacity = optional(number, 1)
    min_capacity = optional(number, 0)
  })
  default = {
    max_capacity = 1
    min_capacity = 0
  }
  validation {
    error_message = "max_capacity must be greater or equal to min_capacity."
    condition     = var.scaling.max_capacity >= var.scaling.min_capacity
  }
  validation {
    error_message = "min_capacity must be one of 0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 384."
    condition     = contains([0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 384], var.scaling.min_capacity)
  }
  validation {
    error_message = "max_capacity must be one of 1, 2, 4, 8, 16, 32, 64, 128, 256, 384."
    condition     = contains([1, 2, 4, 8, 16, 32, 64, 128, 256, 384], var.scaling.max_capacity)
  }
}
locals {
  scaling = merge(var.scaling, {
    min_capacity = local.is_mysql && var.engine_version == "5.7" && var.scaling.min_capacity == 0 ? 1 : var.scaling.min_capacity
  })
}
variable "instance_class" {
  type        = string
  description = "The instance class to use for the RDS instance"
  default     = "db.t4g.small"
}

