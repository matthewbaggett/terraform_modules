variable "stack_name" {
  description = "The name of the collective stack"
  type        = string
}
variable "volume_name" {
  description = "The name of the volume"
  type        = string
}

variable "bucket_name" {
  description = "Override the generated name of the S3 bucket to create"
  type        = string
  default     = null
}
variable "subdir" {
  default     = ""
  description = "The subdirectory to mount in the S3 bucket"
  type        = string
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Resource Tags to apply to this bucket"
}
variable "image_s3_plugin" {
  type        = string
  description = "The docker image to use for the service."
  default     = "rexray/s3fs:0.11.4"
}

variable "application" {
  description = "The AWS myApplication to be associated with this cluster"
  type = object({
    arn             = string
    name            = string
    description     = string
    application_tag = map(string)
  })
  default = null
}