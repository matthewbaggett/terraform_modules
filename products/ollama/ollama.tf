module "network" {
  source     = "../../docker/network"
  stack_name = var.stack_name
}
module "ollama" {
  source                     = "../../docker/service"
  stack_name                 = var.stack_name
  service_name               = "ollama"
  image                      = "${var.image}:${var.tag}"
  converge_enable            = false
  ports                      = [{ host = 11434, container = 7869 }]
  start_first                = false
  placement_constraints      = var.placement_constraints
  networks                   = [module.network]
  reserved_generic_resources = var.reserved_generic_resources
  volumes = {
    "data" = "/root/.ollama"
  }
  environment_variables = {
    OLLAMA_KEEP_ALIVE = "3h"
  }
}
module "webui" {
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "ollama-webui"
  image                 = "${var.webui_image}:${var.webui_tag}"
  converge_enable       = false
  ports                 = [{ host = 8080, container = 8080 }]
  start_first           = false
  placement_constraints = var.placement_constraints
  networks              = [module.network]
  volumes = {
    "webui-data" = "/app/backend/data"
  }
  environment_variables = {
    OLLAMA_BASE_URLS = "http://host.docker.internal:7869" #comma separated ollama hosts
    ENV              = "dev"
    WEBUI_AUTH       = "False"
    WEBUI_NAME       = "valiantlynx AI"
    WEBUI_URL        = "http://localhost:8080"
    WEBUI_SECRET_KEY = "t0p-s3cr3t"
  }
}
