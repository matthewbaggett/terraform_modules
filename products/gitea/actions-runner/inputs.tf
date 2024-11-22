variable "gitea_actions_runner_image" {
  default     = "gitea/act_runner"
  type        = string
  description = "The docker image to use for the gitea runner service."
}
variable "gitea_actions_runner_version" {
  default     = "latest"
  type        = string
  description = "The version of the docker image to use for the gitea runner service."
}
variable "parallelism" {
  description = "The number of instances of the runner to run"
  type        = number
  default     = 2
}
variable "gitea_runner_name" {
  description = "The name to use for the runner"
  type        = string
  default     = null
}
variable "gitea_runner_labels" {
  description = "The labels to use for the runner"
  type        = list(string)
  default     = []
}
variable "gitea_instance_url" {
  type        = string
  description = "The url of the gitea instance to register the runner with."
}
variable "gitea_token" {
  type        = string
  description = "The gitea token to use to register the runner."
}

# Pass-thru variables
variable "service_name" {
  type        = string
  description = "The name of the service to deploy."
  default     = "gitea-actions-runner"
}
variable "stack_name" {
  type        = string
  description = "The name of the stack to deploy the service to."
}
variable "placement_constraints" {
  default     = []
  type        = list(string)
  description = "Docker Swarm placement constraints"
}