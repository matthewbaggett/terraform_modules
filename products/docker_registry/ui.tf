locals {
  docker_registry_ui_conf = {
    SINGLE_REGISTRY        = "true"
    REGISTRY_TITLE         = var.registry_name
    NGINX_PROXY_PASS_URL   = "http://${module.docker_registry.docker_service.name}:5000"
    DELETE_IMAGES          = var.enable_delete ? "true" : "false"
    SHOW_CONTENT_DIGEST    = "true"
    SHOW_CATALOG_NB_TAGS   = "true"
    CATALOG_MIN_BRANCHES   = 1
    CATALOG_MAX_BRANCHES   = 1
    TAGLIST_PAGE_SIZE      = 100
    REGISTRY_SECURED       = false
    CATALOG_ELEMENTS_LIMIT = 1000
  }
}
resource "local_file" "ui_debug" {
  content         = yamlencode(local.docker_registry_ui_conf)
  filename        = "${path.root}/.debug/docker-registry/ui.yml"
  file_permission = "0600"
}

# Registry UI
module "docker_registry_ui" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "ui"
  image                 = "joxit/docker-registry-ui:main"
  environment_variables = local.docker_registry_ui_conf
  networks              = [module.registry_network, var.traefik.network, ]
  placement_constraints = var.placement_constraints
  traefik               = merge(var.traefik, { port = 80, rule = "Host(`${var.domain}`) && !PathPrefix(`/v2`)" })
}

variable "traefik" {
  default = null
  type = object({
    domain  = string
    port    = optional(number, 80)
    non-ssl = optional(bool, true)
    ssl     = optional(bool, false)
    rule    = optional(string)
    network = optional(object({
      name = string
      id   = string
    }))
  })
  description = "Whether to enable traefik for the service."
}