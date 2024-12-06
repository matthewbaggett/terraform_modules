
locals{
  registry_config_yaml = {
    version = 0.1
    storage = {
      s3 = {
        accesskey      = var.s3_accesskey
        secretkey      = var.s3_secretkey
        region         = var.s3_region
        regionendpoint = var.s3_regionendpoint
        forcepathstyle = var.s3_forcepathstyle
        bucket         = var.s3_bucket
      }
      delete = {
        enabled = var.enable_delete
      }
    }
    http = {
      addr   = "0.0.0.0:5000"
      secret = random_password.http_secret.result
      host   = var.domain
      headers = {
        Access-Control-Allow-Origin      = ["https://${var.domain}", ] // @todo add s3 domain here
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

# Configuration file
module "docker_registry_config" {
  source = "../../docker/config"
    name   = "docker-registry-config"
  stack_name = var.stack_name
  value = yamlencode(local.registry_config_yaml)
}
resource "local_file" "docker_registry_config_yml" {
  content  = yamlencode(local.registry_config_yaml)
  filename = "${path.root}/.debug/docker-registry/config.yml"
}

# Registry Service
module "docker_registry" {
  source       = "../../docker/service"
  stack_name   = var.stack_name
  service_name = "registry"
  image        = "registry:2"
  configs = {
    "/etc/docker/registry/config.yml" = nonsensitive(yamlencode(local.registry_config_yaml))
    "/etc/docker/registry/htpasswd"   = nonsensitive(local.registry_htpasswd)
  }
  restart_policy        = "on-failure"
  placement_constraints = var.placement_constraints
  networks              = [module.registry_network]
  ports = [
    {
      host      = 5000
      container = 5000
    }
  ]
}
