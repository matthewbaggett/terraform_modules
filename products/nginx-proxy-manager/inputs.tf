variable "enable" {
  default     = true
  type        = bool
  description = "Whether to enable the service or to merely provision the service."
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
  default     = "nginx-proxy"
}
variable "publish_mode" {
  type        = string
  description = "The publish mode for the service."
  default     = "ingress"
}
variable "data_persist_path" {
  type        = string
  description = "The path to persist data to."
  default     = "/data/nginx-proxy-manager"
}
