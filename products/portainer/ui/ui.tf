resource "random_password" "password" {
  length = 32
}
resource "random_password" "salt" {
  length = 8
}
resource "htpasswd_password" "hash" {
  password = random_password.password.result
  salt     = random_password.salt.result
}
data "docker_registry_image" "portainer_app" {
  name = "portainer/portainer-ce:${var.portainer.version}"
}
resource "docker_volume" "portainer" {
  name = var.docker.name
}
resource "docker_service" "portainer" {
  name = var.docker.name
  mode {
    replicated {
      replicas = 1
    }
  }
  task_spec {
    container_spec {
      image = "${data.docker_registry_image.portainer_app.name}@${data.docker_registry_image.portainer_app.sha256_digest}"
      command = [
        "/portainer",
        //"--edge-compute",
        "--logo", coalesce(var.portainer.logo),
        "--admin-password", htpasswd_password.hash.bcrypt,
      ]
      #mounts {
      #  target    = "/data"
      #  source    = "/portainer"
      #  read_only = false
      #  type      = "bind"
      #}
      mounts {
        target    = "/data"
        source    = docker_volume.portainer.name
        type      = "volume"
        read_only = false
      }
      #mounts {
      #  target    = "/var/run/docker.sock"
      #  source    = "/var/run/docker.sock"
      #  read_only = false
      #  type      = "bind"
      #}
      labels {
        label = "com.docker.stack.namespace"
        value = var.docker.stack_name
      }
    }
    dynamic "networks_advanced" {
      for_each = var.docker.networks
      content {
        name = networks_advanced.value.id
      }
    }
    restart_policy {
      condition    = "on-failure"
      delay        = "3s"
      max_attempts = 4
      window       = "10s"
    }
    placement {
      constraints = [
        "node.role == manager",
        "node.platform.os == linux",
      ]
    }
  }
  #endpoint_spec {
  #  ports {
  #    target_port    = 9000
  #    publish_mode   = "ingress"
  #    published_port = 9000
  #  }
  #  ports {
  #    target_port    = 8000
  #    publish_mode   = "ingress"
  #    published_port = 8000
  #  }
  #}
  update_config {
    # Portainer gets super fuckin' upset if you start a second instance while the first is holding the db lock
    order = "stop-first"
  }

  labels {
    label = "com.docker.stack.namespace"
    value = var.docker.stack_name
  }
  labels {
    label = "com.docker.stack.image"
    value = replace(data.docker_registry_image.portainer_app.name, "/:.*/", "")
  }
  lifecycle {
    ignore_changes = [
      # MB: This is a hack because terraform keeps detecting a "change" in the placement->platform constraint that doesn't exist.
      task_spec[0].placement[0].platforms
    ]
  }
}
