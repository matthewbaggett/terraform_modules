data "docker_registry_image" "image" {
  name = var.image
}

resource "docker_service" "instance" {
  # The name of the service is the stack name and the service name combined
  name = local.service_name

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

      # Mount all the volumes being remotely attached to the container
      dynamic "mounts" {
        for_each = var.remote_volumes
        content {
          target = mounts.value
          source = mounts.key
          type   = "volume"
        }
      }

      # Iterate through "mounts" to bind host paths to container paths
      dynamic "mounts" {
        for_each = var.mounts
        content {
          target    = mounts.value
          source    = mounts.key
          type      = "bind"
          read_only = false # Nice assumption bro.
        }
      }

      # Iterate through configs and attach the docker configs
      dynamic "configs" {
        for_each = var.configs
        content {
          config_id   = module.config[configs.key].id
          config_name = module.config[configs.key].name
          file_name   = configs.value
        }
      }

      # Allow overriding DNS server in use
      dynamic "dns_config" {
        for_each = var.dns_nameservers != null ? [{}] : []
        content {
          nameservers = var.dns_nameservers
        }
      }

      # Apply the healthcheck settings
      healthcheck {
        test         = var.healthcheck != null ? var.healthcheck : []
        interval     = var.healthcheck != null ? "10s" : "0s"
        timeout      = var.healthcheck != null ? "3s" : "0s"
        retries      = 0
        start_period = "0s"
      }

      # Apply the list of Container Labels
      dynamic "labels" {
        for_each = local.labels
        content {
          label = labels.key
          value = labels.value
        }
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
      condition    = var.one_shot ? "none" : var.restart_policy
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

  # Behaviour regarding startup and delaying/waiting.
  # Converging is not possible when:
  #  * in global deploy mode
  #  * in one-shot mode
  #  * converging is disabled
  #  * the service does not have a well-defined healthcheck, maybe you should add one to the service, or to the container itself ideally.
  dynamic "converge_config" {
    for_each = var.converge_enable && !var.global && !var.one_shot ? [{}] : []
    content {
      delay   = "5s"
      timeout = var.converge_timeout
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
  dynamic "labels" {
    for_each = local.labels
    content {
      label = labels.key
      value = labels.value
    }
  }
}
