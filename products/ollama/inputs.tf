variable "placement_constraints" {
  type        = list(string)
  description = "A list of placement constraints to apply to the service."
  default     = []
}
variable "stack_name" {
  type        = string
  description = "Stack Name"
  default     = "ollama"
}
variable "image" {
  type        = string
  default     = "ollama/ollama"
  description = "The docker image to use."
}
variable "tag" {
  type        = string
  description = "Tag of the docker image to use."
  default     = "latest"
}
variable "webui_image" {
  type = string
  default = "ghcr.io/open-webui/open-webui"
  description = "The docker image to use for the webui."
}
variable "webui_tag" {
  type        = string
  description = "Tag of the docker image to use."
  default     = "main"
}
variable "reserved_generic_resources" {
  default     = []
  type        = list(string)
  description = "A list of generic resources to reserve for the service."
}