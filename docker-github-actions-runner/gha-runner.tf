module "github_actions_runner" {
  source                = "../docker-service"
  service_name          = var.service_name
  stack_name            = var.stack_name
  placement_constraints = var.placement_constraints
  image                 = "${var.github_actions_runner_image}:${var.github_actions_runner_version}"
  parallelism           = var.parallelism
  environment_variables = {
    RUNNER_NAME_PREFIX  = var.github_runner_name_prefix
    RUNNER_SCOPE        = "org"
    ORG_NAME            = var.github_org_name
    ACCESS_TOKEN        = var.github_token
    RUNNER_WORKDIR      = "/github/workspace"
    LABELS              = join(",", var.github_runner_labels)
    EPHEMERAL           = true
    DISABLE_AUTO_UPDATE = "disable_updates"
  }
  mounts = {
    "/var/run/docker.sock" = "/var/run/docker.sock"
  }
}