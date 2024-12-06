variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}
variable "stack_name" {
  type = string
  default = "docker-registry"
  description = "The name of the stack"
}
variable "registry_users" {
  type = list(object({
    username = string
    password = optional(string)
  }))
  description = "A list of users to create in the registry"
}
variable "enable_delete" {
    type = bool
    default = false
    description = "Enable the delete feature in the registry"
}
variable "s3_accesskey" {
  type = string
  description = "The access key for the S3 bucket"
}
variable "s3_secretkey" {
  type = string
  description = "The secret key for the S3 bucket"
}
variable "s3_region" {
  type = string
  description = "The region for the S3 bucket"
}
variable "s3_regionendpoint" {
  type = string
  description = "The region endpoint for the S3 bucket"
  default = null
}
variable "s3_forcepathstyle" {
  type = bool
  description = "Force path style for the S3 bucket"
  default = false
}
variable "s3_bucket" {
  type = string
  description = "The bucket name for the S3 bucket"
}
variable "domain" {
    type = string
    description = "The domain for the registry"
}