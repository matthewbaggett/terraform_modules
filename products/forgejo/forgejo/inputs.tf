variable "enable" {
  type        = bool
  description = "Whether to enable the services or merely provision them."
  default     = true
}
variable "forgejo_image" {
  default     = "code.forgejo.org/forgejo/forgejo"
  type        = string
  description = "The docker image to use for the forgejo runner service."
}
variable "forgejo_version" {
  default     = "12"
  type        = string
  description = "The version of the docker image to use for the forgejo runner service."
}

variable "forgejo_slogan" {
  type        = string
  description = "The slogan to use for the forgejo instance."
  default     = ""
}
variable "forgejo_name" {
  type        = string
  description = "The name to use for the forgejo instance."
  default     = "Forgejo"
}
variable "forgejo_email" {
  type        = string
  description = "The email to use for the forgejo instance."
  default     = "forgejo@example.com"
}
variable "ssh_port" {
  type        = number
  description = "The port to use for ssh."
  default     = 2222
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
  default     = "forgejo"
}

variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker placement constraints"
}
variable "networks" {
  type = list(object({
    name = string
    id   = string
  }))
  default     = []
  description = "A list of network names to attach the service to."
}
variable "mounts" {
  #host=>container
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. Key is Host path, Value is Container path"
}

variable "data_storage_path" {
  type        = string
  description = "Specify path to store the data."
  default     = null
}
variable "database_storage_path" {
  type        = string
  description = "Specify path to store the database data."
  default     = null
}

variable "traefik" {
  default = null
  type = object({
    domain           = string
    port             = optional(number)
    non-ssl          = optional(bool, true)
    ssl              = optional(bool, false)
    rule             = optional(string)
    middlewares      = optional(list(string))
    network          = optional(object({ name = string, id = string }))
    basic-auth-users = optional(list(string))
  })
  description = "Whether to enable traefik for the service."
}