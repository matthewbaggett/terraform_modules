variable "image" {
  description = "The headscale image to deploy"
  default = "headscale/headscale:0.22.3"
}
variable "admin_image" {
    description = "The headscale admin image to deploy"
    default = "goodieshq/headscale-admin:0.1.7b"
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