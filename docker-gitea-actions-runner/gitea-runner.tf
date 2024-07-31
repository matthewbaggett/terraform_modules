module "gitea_actions_runner" {
  source                = "../docker-service"
  service_name          = var.service_name
  stack_name            = var.stack_name
  placement_constraints = var.placement_constraints
  image                 = "${var.gitea_actions_runner_image}:${var.gitea_actions_runner_version}"
  parallelism           = var.parallelism
  environment_variables = {
    GITEA_INSTANCE_URL              = var.gitea_instance_url
    GITEA_RUNNER_NAME               = var.gitea_runner_name
    GITEA_RUNNER_LABELS             = join(",", var.gitea_runner_labels)
    GITEA_RUNNER_REGISTRATION_TOKEN = var.gitea_token
    CONFIG_FILE                     = "/config.yaml"
  }
  mounts = {
    "/var/run/docker.sock" = "/var/run/docker.sock"
  }
  configs = {
    gitea-config = {
      name_prefix = ["gitea-config", var.stack_name, var.service_name]
      path        = "/config.yaml"
      contents = yamlencode({
        log = {
          level = "info"
        }
        runner = {
          file           = ".runner"
          capacity       = 2
          env_file       = ".env"
          timeout        = "3h"
          insecure       = false
          fetch_timeout  = "5s"
          fetch_interval = "2s"
          labels         = var.gitea_runner_labels
        }
        cache = {
          enabled         = true
          dir             = ""
          host            = ""
          port            = 0
          external_server = ""
        }
        container = {
          network        = null
          privileged     = false
          options        = null
          workdir_parent = null
          valid_volumes  = []
          docker_host    = ""
          force_pull     = true
          force_rebuild  = false
        }
        host = {
          workdir_parent : null
        }
      })
    }
  }
}