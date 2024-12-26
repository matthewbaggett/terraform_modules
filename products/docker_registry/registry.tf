resource "random_password" "http_secret" {
  length = 16
}
locals {
  registry_config_yaml = {
    version = 0.1
    storage = {
      s3 = nonsensitive(var.s3)
      delete = {
        enabled = var.enable_delete
      }
    }
    http = {
      addr   = "0.0.0.0:5000"
      secret = nonsensitive(random_password.http_secret.result)
      host   = var.domain
      headers = {
        Access-Control-Allow-Origin      = concat(["https://${var.domain}", ], formatlist("https://%s", var.cors_domains))
        Access-Control-Allow-Methods     = ["HEAD", "GET", "DELETE", "OPTIONS"]
        Access-Control-Allow-Credentials = ["true"]
        Access-Control-Allow-Headers     = ["Authorization", "Cache-Control", "Accept"]
        Access-Control-Expose-Headers    = ["Docker-Content-Digest"]
      }
    }
    redis = {
      addrs    = ["${module.docker_registry_redis.service_name}:6379"]
      password = module.docker_registry_redis.auth
      db       = 0
    }
    validation = {
      manifests = {
        urls = {
          allow = [
            "^https?://${var.domain}/"
          ]
        }
      }
    }
    auth = {
      htpasswd = {
        realm = "Registry Realm"
        path  = "/etc/docker/registry/htpasswd"
      }
    }
  }
}
module "docker_registry" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "registry"
  image                 = "registry:2"
  restart_policy        = "on-failure"
  placement_constraints = var.placement_constraints
  ports                 = [{ container = 5000 }]
  networks              = concat([module.registry_network, var.traefik.network, ], var.networks)
  traefik               = merge(var.traefik, { port = 5000, rule = "Host(`${var.domain}`) && PathPrefix(`/v2`)" })
  configs = {
    "/etc/docker/registry/config.yml" = yamlencode(local.registry_config_yaml)
    "/etc/docker/registry/htpasswd"   = local.registry_htpasswd
  }
}
