variable "placement_constraints" {
  type        = list(string)
  default     = []
  description = "Docker Swarm placement constraints"
}
variable "downloader" {
  type        = string
  description = "The name to report to archiveteam.org"
}
variable "http_username" {
  type        = string
  description = "The username for the HTTP Basic Auth"
  default     = null
}
variable "http_password" {
  type        = string
  description = "The password for the HTTP Basic Auth"
  default     = null
}
variable "selected_project" {
  type        = string
  description = "The project to run"
  default     = "auto"
}
variable "concurrency" {
  type        = number
  description = "The number of concurrent downloads"
  default     = 5
}
variable "warrior_instances" {
  type        = number
  description = "The number of warrior instances"
  default     = 1
}
variable "shared_rsync_threads" {
  type        = number
  description = "The number of rsync threads to use"
  default     = 2
}
resource "random_password" "warrior_password" {
  count   = var.http_password == null ? 1 : 0
  length  = 32
  special = false
}
variable "port" {
  type        = number
  description = "The port to expose the warrior on"
  default     = 8001
}
variable "service_name" {
  type        = string
  description = "The name of the service to create."
  default     = "warrior"
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
  default     = "archiveteam"
}
variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool)
    ssl              = optional(bool)
    rule             = optional(string)
    middlewares      = optional(list(string))
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string))
    headers          = optional(map(string))
    udp_entrypoints  = optional(list(string)) # List of UDP entrypoints
  })
  description = "Whether to enable traefik for the service."
}