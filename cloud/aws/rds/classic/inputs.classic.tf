variable "instance_class" {
  type        = string
  description = "The instance class to use for the RDS instance"
  default     = "db.t4g.small"
}