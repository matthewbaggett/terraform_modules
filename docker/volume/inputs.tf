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
  description = "A map of labels to apply to the volume."
}
variable "bind_path" {
  type        = string
  default     = null
  description = "The path to bind the volume to, optionally."
}
variable "driver" {
  type = string
  default = null
}
variable "driver_opts" {
  type = map(string)
  default = {}
}