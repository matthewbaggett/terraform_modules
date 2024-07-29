data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}
resource "random_id" "iteration" {
  keepers = {
    configs = jsonencode(var.configs)
  }
  byte_length = 4
}
resource "docker_service" "nginx" {
  name = var.service_name
  mode {
    replicated {
      replicas = var.replicas
    }
  }
  task_spec {
    container_spec {
      image = "${data.docker_registry_image.nginx.name}@${data.docker_registry_image.nginx.sha256_digest}"
      configs {
        config_id   = docker_config.default_page.id
        config_name = docker_config.default_page.name
        file_name   = "/usr/share/nginx/html/index.html"
      }
      configs {
        config_id   = docker_config.default_conf.id
        config_name = docker_config.default_conf.name
        file_name   = "/etc/nginx/conf.d/default.conf"
      }
      dynamic "configs" {
        for_each = var.configs
        content {
          config_id   = configs.value.id
          config_name = configs.value.name
          file_name   = "/etc/nginx/conf.d/${configs.value.file}"
        }
      }
      # Healthcheck that checks that the nginx process is running
      #healthcheck {
      #  test         = ["CMD", "pgrep", "nginx"]
      #  interval     = "10s"
      #  timeout      = "5s"
      #  retries      = 3
      #  start_period = "10s"
      #}
      healthcheck {
        test = ["CMD", "true"]
      }
      labels {
        label = "com.nginx.iteration-id"
        value = random_id.iteration.hex
      }
    }
    dynamic "networks_advanced" {
      for_each = var.networks
      content {
        name = networks_advanced.value.id
      }
    }
    placement {
      constraints = var.placement_constraints
    }
  }
  endpoint_spec {
    ports {
      target_port    = 80
      publish_mode   = "ingress"
      published_port = 80
    }
    ports {
      target_port    = 443
      publish_mode   = "ingress"
      published_port = 443
    }
  }
  update_config {
    parallelism = ceil(var.replicas / 3)
    delay       = "10s"
    order       = "start-first"
  }
  lifecycle {
    ignore_changes = [
      task_spec[0].placement[0].platforms,
    ]
  }
}
