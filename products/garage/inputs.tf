variable "placement_constraints" {
  type        = list(string)
  description = "A list of placement constraints to apply to the service."
  default     = []
}
variable "stack_name" {
  type        = string
  description = "Stack Name"
}
variable "service_name" {
    type        = string
    description = "Service Name"
  default = "garage"
}
variable "image" {
  type        = string
  default     = "dxflrs/garage"
  description = "The docker image to use."
}
variable "tag" {
  type        = string
  default = "v2.1.0"
  description = "Tag of the docker image to use."
}
variable "domain" {
  type        = string
  description = "Domain to use e.g s3.example.org"
}
variable "rpc_public_addr" {
    type        = string
    description = "This is how other garage services will reach garage. e.g 'garage.s3.example.org:3901'"
}
variable "s3_port" {
  type        = number
  description = "Port to bind the s3 server to."
  default     = 3900
}
variable "rpc_port" {
    type        = number
    description = "Port to bind the rpc server to."
    default     = 3901
}
variable "web_port" {
    type        = number
    description = "Port to bind the web server to."
    default     = 3902
}
variable "admin_port" {
  type = number
    description = "Port to bind the admin server to."
    default = 3903
}
variable "s3_region" {
    type        = string
    description = "The S3 region to report via the API."
    default     = "us-east-1"
}
variable "replication_factor" {
  type = number
  description = "The replication factor to use for the garage service."
  default = 1
}