variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
}
variable "name" {
  type        = string
  description = "The name of the docker config."
}
variable "value" {
  type        = string
  description = "The value of the docker config."
}
variable "labels" {
  type        = map(string)
  default     = {}
  description = "A map of labels to apply to the service"
}
variable "debug" {
  type        = bool
  default     = true
  description = "Emit debug files in .debug directory"
}