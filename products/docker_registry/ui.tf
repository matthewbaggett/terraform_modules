
# Registry UI
module "docker_registry_ui" {
  source       = "../../docker/service"
  stack_name   = var.stack_name
  service_name = "ui"
  image        = "joxit/docker-registry-ui:main"
  environment_variables = {
    SINGLE_REGISTRY        = "true"
    REGISTRY_TITLE         = "Grey.ooo Docker Registry"
    NGINX_PROXY_PASS_URL   = "http://${module.docker_registry.docker_service.name}:5000"
    DELETE_IMAGES          = "true"
    SHOW_CONTENT_DIGEST    = "true"
    SHOW_CATALOG_NB_TAGS   = "true"
    CATALOG_MIN_BRANCHES   = 1
    CATALOG_MAX_BRANCHES   = 1
    TAGLIST_PAGE_SIZE      = 100
    REGISTRY_SECURED       = false
    CATALOG_ELEMENTS_LIMIT = 1000
  }
  networks              = [module.registry_network, var.traefik.network, ]
  placement_constraints = var.placement_constraints
  traefik               = var.traefik
}

variable "traefik" {
  default = null
  type = object({
    domain = string
    port   = optional(number)
    ssl    = optional(bool, false)
    rule   = optional(string)
    network = optional(object({
      id = string
      name = string
    }))
  })
  description = "Whether to enable traefik for the service."
}
