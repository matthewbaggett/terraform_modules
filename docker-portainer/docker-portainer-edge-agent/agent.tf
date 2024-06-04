//resource "random_uuid" "edge_id" {}
data "docker_registry_image" "portainer_agent" {
  name = "portainer/agent:${var.portainer.version}"
}
resource "docker_network" "portainer_edge_network" {
  name   = "portainer_edge_network"
  driver = "overlay"
  labels {
    label = "com.docker.stack.namespace"
    value = var.docker.stack_name
  }
  lifecycle {
    ignore_changes = [
      ipam_config,
    ]
  }
}
resource "docker_service" "portainer_edge_agent" {
  name = var.docker.name_agent
  mode {
    global = true
  }
  task_spec {
    container_spec {
      image   = "${data.docker_registry_image.portainer_agent.name}@${data.docker_registry_image.portainer_agent.sha256_digest}"
      command = concat(["./agent"], var.debug ? ["--log-level", "DEBUG"] : [])
      env = {
        AGENT_CLUSTER_ADDR = "tasks.${var.docker.name_agent}"
        EDGE               = 1
        EDGE_ID            = var.edge_id
        #EDGE_KEY           = local.edge_key
        EDGE_KEY           = var.edge_key
        EDGE_INSECURE_POLL = 1
      }
      mounts {
        target    = "/var/run/docker.sock"
        source    = "/var/run/docker.sock"
        read_only = false
        type      = "bind"
      }
      mounts {
        target    = "/var/lib/docker/volumes"
        source    = "/var/lib/docker/volumes"
        read_only = false
        type      = "bind"
      }
      mounts {
        target    = "/host"
        source    = "/"
        read_only = false
        type      = "bind"
      }
      // MB:Might need to add a portainer_agent_data volume (not bind) here mounting int /data
      labels {
        label = "com.docker.stack.namespace"
        value = var.docker.stack_name
      }
    }
    networks_advanced {
      name = docker_network.portainer_edge_network.id
    }
    restart_policy {
      condition = "on-failure"
      delay     = "0s"
      #max_attempts = -1
      window = "10s"
    }
    placement {
      constraints = [
        "node.platform.os == linux"
      ]
      platforms {
        architecture = "amd64"
        os           = "linux"
      }
    }
    resources {
      limits {
        nano_cpus    = 30 * 10000000
        memory_bytes = 256 * 1000000
      }
      reservation {
        nano_cpus    = 5 * 10000000
        memory_bytes = 64 * 1000000
      }
    }
  }
  update_config {
    order = "stop-first"
  }
  labels {
    label = "com.docker.stack.namespace"
    value = var.docker.stack_name
  }
  labels {
    label = "com.docker.stack.image"
    value = replace(data.docker_registry_image.portainer_agent.name, "/:.*/", "")
  }
}
