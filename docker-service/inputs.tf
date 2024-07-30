variable "image" {
  type = string
}
variable "command" {
  type    = list(string)
  default = null
}
variable "one_shot" {
  type        = bool
  default     = false
  description = "Whether to run the service as a one-shot task."
}
variable "stack_name" {
  type = string
}
variable "service_name" {
  type = string
}
variable "environment_variables" {
  type    = map(string)
  default = {}
}
variable "networks" {
  type    = list(string)
  default = []
}
variable "healthcheck" {
  type    = list(string)
  default = null
}
variable "volumes" {
  type    = map(string)
  default = {}
}
variable "ports" {
  type        = map(number)
  default     = {}
  description = "A map of port mappings to expose on the host. The key is the host port, and the value is the container port."
}

# Scaling and deployment variables
variable "parallelism" {
  default     = 1
  type        = number
  description = "The number of instances to run."
}
variable "update_waves" {
  default     = 3
  type        = number
  description = "When updating a multi-instance service, the number of waves of updates to run."
}
variable "start_first" {
  default     = true
  type        = bool
  description = "When updating a multi-instance service, whether to start or stop instances first. Start-first allows for a clean handoff, but not every instance is capable of this."
}
variable "global" {
  default     = false
  type        = bool
  description = "Whether to run the service globally (or replicated if false)."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "processor_architecture" {
  default = "amd64"
  type    = string
}
variable "operating_system" {
  default = "linux"
  type    = string
}
