variable "image" {
  description = "The headscale image to deploy"
  default     = "headscale/headscale:stable"
}
variable "admin_image" {
  description = "The headscale admin image to deploy"
  default     = "simcu/headscale-ui"
}
variable "stack_name" {
  description = "The name of the stack"
  default     = "headscale"
}
variable "domain" {
  description = "The domain for the headscale service"
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}