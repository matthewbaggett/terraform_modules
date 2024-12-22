

resource "docker_service" "instance" {
  # The name of the service is the stack name and the service name combined
  name = local.service_name

  # Define the task spec
  task_spec {
    container_spec {
      image   = local.image_fully_qualified
      command = var.command
      env     = var.environment_variables

      # Mount all the created volumes
      dynamic "mounts" {
        for_each = var.volumes
        content {
          source    = docker_volume.volume[mounts.key].id
          target    = mounts.value
          type      = "volume"
          read_only = false # Nice assumption bro.
        }
      }

      # Mount all the volumes being remotely attached to the container
      dynamic "mounts" {
        for_each = var.remote_volumes
        content {
          source    = mounts.value.id
          target    = mounts.key
          type      = "volume"
          read_only = false # Nice assumption bro.
        }
      }

      # Iterate through "mounts" to bind host paths to container paths
      dynamic "mounts" {
        for_each = var.mounts
        content {
          source    = mounts.key
          target    = mounts.value
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
          file_name   = configs.key
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
        interval     = var.healthcheck != null ? var.healthcheck_interval : "0s"
        timeout      = var.healthcheck != null ? var.healthcheck_timeout : "0s"
        retries      = var.healthcheck_retries
        start_period = var.healthcheck_start_period
      }

      # Apply the list of Container Labels
      dynamic "labels" {
        # Filter out null values
        for_each = { for key, value in local.labels : key => value if value != null }
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
        name = networks_advanced.value.id
      }
    }

    # Apply restart policy
    restart_policy {
      condition    = var.one_shot ? "none" : var.restart_policy
      delay        = var.restart_delay
      window       = "0s"
      max_attempts = 0
    }

    # Apply the placement constraints
    placement {
      max_replicas = var.parallelism_per_node
      constraints  = var.placement_constraints
      platforms {
        architecture = var.processor_architecture
        os           = var.operating_system
      }
    }

    # Apply the resource limits and reservations
    resources {
      limits {
        memory_bytes = var.limit_ram_mb != null ? 1024 * 1024 * var.limit_ram_mb : 0
        nano_cpus    = var.limit_cpu != null ? (1000000000 / 100) * var.limit_cpu : 0
      }
      reservation {
        memory_bytes = var.reserved_ram_mb != null ? 1024 * 1024 * var.reserved_ram_mb : 0
        nano_cpus    = var.reserved_cpu != null ? (1000000000 / 100) * var.reserved_cpu : 0
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
    for_each = { for key, value in local.labels : key => value if value != null }
    content {
      label = labels.key
      value = labels.value
    }
  }

  lifecycle {
    # Help prevent "this service already exists" irritations
    create_before_destroy = false
  }
}
