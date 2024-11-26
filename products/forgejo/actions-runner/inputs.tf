variable "forgejo_actions_runner_image" {
  default     = "code.forgejo.org/forgejo/runner"
  type        = string
  description = "The docker image to use for the forgejo runner service."
}
variable "forgejo_actions_runner_version" {
  default     = "latest"
  type        = string
  description = "The version of the docker image to use for the forgejo runner service."
}
variable "parallelism" {
  description = "The number of instances of the runner to run"
  type        = number
  default     = 2
}
variable "forgejo_runner_name" {
  description = "The name to use for the runner"
  type        = string
  default     = null
}
variable "forgejo_runner_labels" {
  description = "The labels to use for the runner"
  type        = list(string)
  default = [
    "self-hosted:docker://gitea/runner-images:ubuntu-latest",
    "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest",
    "ubuntu-24.04:docker://gitea/runner-images:ubuntu-24.04",
    "ubuntu-22.04:docker://gitea/runner-images:ubuntu-22.04",
    "ubuntu-20.04:docker://gitea/runner-images:ubuntu-20.04",
  ]
}
variable "forgejo_instance_url" {
  type        = string
  description = "The url of the forgejo instance to register the runner with."
}
variable "forgejo_token" {
  type        = string
  description = "The forgejo token to use to register the runner."
}

# Pass-thru variables
variable "service_name" {
  type        = string
  description = "The name of the service to deploy."
  default     = "forgejo-actions-runner"
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