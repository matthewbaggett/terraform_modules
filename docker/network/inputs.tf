variable "stack_name" {
  description = "The name of the collective stack"
  type        = string
}
variable "labels" {
  type        = map(string)
  default     = {}
  description = "A map of labels to apply to the service"
}

variable "network_name" {
  type        = string
  description = "Override the automatically selected name of the network"
  default     = null
}

variable "subnet" {
  type        = string
  description = "The subnet to use for the network."
  default     = null //"172.16.0.0/16"
}
