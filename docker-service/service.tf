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
    parallelism = ceil(var.parallelism / var.update_waves)
    order       = var.start_first ? "start-first" : "stop-first"
  }

  # Ports and such
  endpoint_spec {
    dynamic "ports" {
      for_each = var.ports
      content {
        target_port    = ports.value
        published_port = ports.key
        protocol       = "tcp"
        publish_mode   = "ingress"
      }
    }
    dynamic "ports" {
      for_each = var.ports
      content {
        target_port    = ports.value
        published_port = ports.key
        protocol       = "udp"
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