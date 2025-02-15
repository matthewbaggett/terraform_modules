module "forgejo_actions_runner" {
  source                = "../../../docker/service"
  enable                = var.enable
  service_name          = var.service_name
  stack_name            = var.stack_name
  placement_constraints = var.placement_constraints
  image                 = "${var.forgejo_actions_runner_image}:${var.forgejo_actions_runner_version}"
  parallelism           = var.parallelism
  converge_enable       = false
  environment_variables = {
    #    forgejo_INSTANCE_URL              = var.forgejo_instance_url
    #    forgejo_RUNNER_NAME               = var.forgejo_runner_name
    #    forgejo_RUNNER_LABELS             = join(",", var.forgejo_runner_labels)
    #    forgejo_RUNNER_REGISTRATION_TOKEN = var.forgejo_token
    #    CONFIG_FILE                       = "/config.yaml"
    #DOCKER_HOST = module.docker_socket_proxy.endpoint
  }
  mounts = {
    "/var/run/docker.sock" = "/var/run/docker.sock"
  }
  networks      = var.networks
  command       = ["/bin/bash", "/entrypoint.sh"]
  restart_delay = "1m"
  configs = {
    "/entrypoint.sh" = <<EOF
#!/bin/bash
set -xe
echo "Configuring runner..."
/bin/forgejo-runner --config /config.yaml register --no-interactive --instance "${var.forgejo_instance_url}" --name ${var.forgejo_runner_name} --token ${var.forgejo_token}
echo "Starting runner..."
exec /bin/forgejo-runner --config /config.yaml daemon
EOF
    "/config.yaml" = yamlencode({
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
        labels         = var.forgejo_runner_labels
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