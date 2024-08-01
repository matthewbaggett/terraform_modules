resource "docker_volume" "volume" {
  for_each = var.volumes
  name     = lower("${var.stack_name}-${replace(each.key, "/", "-")}")
}

data "docker_registry_image" "image" {
  name = var.image
}

resource "docker_service" "instance" {
  # The name of the service is the stack name and the service name combined
  name = "${var.stack_name}-${var.service_name}"

  # Define the task spec
  task_spec {
    container_spec {
      image   = "${data.docker_registry_image.image.name}@${data.docker_registry_image.image.sha256_digest}"
      command = var.command
      env     = var.environment_variables

      # Mount all the created volumes
      dynamic "mounts" {
        for_each = var.volumes
        content {
          target = mounts.value
          source = docker_volume.volume[mounts.key].id
          type   = "volume"
        }
      }
      dynamic "mounts" {
        for_each = var.mounts
        content {
          target = mounts.value
          source = mounts.key
          type   = "bind"
        }
      }

      dynamic "configs" {
        for_each = var.configs
        content {
          config_id   = docker_config.config[configs.key].id
          config_name = docker_config.config[configs.key].name
          file_name   = configs.value.path
        }
      }

      # Allow overriding DNS server in use
      dns_config {
        nameservers = var.dns_nameservers
      }

      # Apply the healthcheck
      dynamic "healthcheck" {
        for_each = var.healthcheck != null ? [var.healthcheck] : []
        content {
          test         = healthcheck.value
          interval     = "10s"
          timeout      = "3s"
          retries      = 0
          start_period = "0s"
        }
      }

      # Container labels
      labels {
        label = "com.docker.stack.namespace"
        value = var.stack_name
      }
    }

    # Apply the networks
    dynamic "networks_advanced" {
      for_each = var.networks
      content {
        name = networks_advanced.value
      }
    }

    # Apply restart policy
    restart_policy {
      condition    = var.one_shot ? "none" : "any"
      delay        = "0s"
      window       = "0s"
      max_attempts = 0
    }

    placement {
      constraints = var.placement_constraints
      platforms {
        architecture = var.processor_architecture
        os           = var.operating_system
      }
    }
  }

  # Global deploy
  dynamic "mode" {
    for_each = var.global ? [{}] : []
    content {
      global = true
    }
  }
  # Or replicated deploy
  dynamic "mode" {
    for_each = !var.global ? [{}] : []
    content {
      replicated {
        replicas = var.parallelism
      }
    }
  }

  # Behaviour regarding startup and delaying/waiting. Not possible in global deploy mode.
  dynamic "converge_config" {
    for_each = !var.global ? [{}] : []
    content {
      delay   = "5s"
      timeout = "2m"
    }
  }

  # How to handle updates/re-deployments
  update_config {
    # Parallelism must be the size of the count of instances, divided by the number of update waves
    # with a minimum of 1.
    # Confusingly, the max() function gives you the largest number of the two, so if the parallelism is 0, 1 will be greater.
    parallelism = max(1, ceil(var.parallelism / var.update_waves))

    # The order of stopping and starting containers.
    # Some containers can be run while the previous is still running (e.g web servers, anything ephemeral)
    # Some cannot have more than 1 instance running at the same time (e.g databases, anything concrete)
    order = var.start_first ? "start-first" : "stop-first"
  }

  # Ports and such
  endpoint_spec {
    dynamic "ports" {
      for_each = var.ports
      content {
        target_port    = ports.value.container
        published_port = ports.value.host
        protocol       = ports.value.protocol
        publish_mode   = "ingress"
      }
    }
  }

  # Service Labels
  labels {
    label = "com.docker.stack.namespace"
    value = var.stack_name
  }
  labels {
    label = "com.docker.stack.image"
    value = var.image
  }
}

resource "docker_config" "config" {
  for_each = var.configs
  data     = base64encode(each.value.contents)
  name     = join("-", concat(each.value.name_prefix, [substr(sha1(each.value.contents), 0, 7)]))
  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "config" {
  for_each = var.configs
  content  = each.value.contents
  filename = "${path.root}/.debug/docker-service/${var.stack_name}-${var.service_name}/configs/${each.key}"
}