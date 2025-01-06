variable "stack_name" {
  description = "The name of the collective stack"
  type        = string
}
variable "volume_name" {
  description = "The name of the volume"
  type        = string
}
variable "labels" {
  type        = map(string)
  default     = {}
  description = "A map of labels to apply to the service"
}
variable "bind_path" {
  type        = string
  default     = null
  description = "The path to bind the volume to, optionally."
}