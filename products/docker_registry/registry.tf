resource "random_password" "http_secret" {
  length = 16
}
locals {
  registry_config_yaml = {
    version = 0.1
    storage = {
      s3 = merge(nonsensitive(var.s3), {
        v4auth    = true
        chunksize = 5242880
        secure    = true
        loglevel  = "on"
      })
      cache = {
        blobdescriptor = "inmemory"
      }
      delete = {
        enabled = var.enable_delete
      }
    }
    http = {
      addr   = ":5000"
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
    health = {
      storagedriver = {
        enabled   = true
        interval  = "10s"
        threshold = 3
      }
    }
    auth = {
      htpasswd = {
        realm = "Registry Realm"
        path  = "/etc/distribution/htpasswd"
      }
    }
    log = {
      fields = {
        service = "registry"
      }
    }
  }
}
module "docker_registry" {
  source                = "../../docker/service"
  debug                 = true
  stack_name            = var.stack_name
  service_name          = "registry"
  image                 = "registry:3"
  restart_policy        = "on-failure"
  placement_constraints = var.placement_constraints
  ports                 = var.ports
  networks              = concat([module.registry_network], var.networks)
  traefik               = merge(var.traefik, { port = 5000, rule = "Host(`${var.domain}`) && PathPrefix(`/v2`)" })
  configs = {
    "/etc/distribution/config.yml" = yamlencode(local.registry_config_yaml)
    "/etc/distribution/htpasswd"   = local.registry_htpasswd
  }
  healthcheck      = ["CMD", "wget", "-q", "http://localhost:5000/", "-O", "/dev/null"]
  converge_enable  = true
  converge_timeout = "2m"
  dns_nameservers  = var.dns_nameservers
  environment_variables = {
    OTEL_TRACES_EXPORTER = "none"
  }
}
