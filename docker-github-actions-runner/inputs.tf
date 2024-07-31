variable "github_actions_runner_image" {
  default     = "myoung34/github-runner"
  type        = string
  description = "The docker image to use for the github actions runner service."
}
variable "github_actions_runner_version" {
  default     = "latest"
  type        = string
  description = "The version of the docker image to use for the github actions runner service."
}

variable "parallelism" {
  description = "The number of instances of the runner to run"
  type        = number
  default     = 2
}
variable "github_runner_name_prefix" {
  description = "The prefix to use for the runner name"
  type        = string
  default     = null
}
variable "github_runner_labels" {
  description = "The labels to use for the runner"
  type        = list(any)
  default     = []
}
variable "github_org_name" {
  type        = string
  description = "The name of the github organization to register the runner with."
}
variable "github_token" {
  type        = string
  description = "The github token to use to register the runner."
}

# Pass-thru variables
variable "service_name" {
  type        = string
  description = "The name of the service to deploy."
  default     = "github-actions-runner"
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