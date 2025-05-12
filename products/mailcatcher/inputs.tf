variable "enable" {
  default     = true
  type        = bool
  description = "Whether to enable the service or to merely provision the service."
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
  default     = "mailcatcher"
}
variable "publish_mode" {
  type        = string
  description = "The publish mode for the service."
  default     = "ingress"
}
variable "placement_constraints" {
  description = "Placement constraints for the service."
  type        = list(string)
  default     = []
}
variable "domain" {
  type        = string
  description = "The domain to use for the service."
  default     = "mailcatcher.example.org"
}