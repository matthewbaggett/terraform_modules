resource "random_pet" "minio_admin_user" {
  length    = 2
  separator = ""
}
resource "random_password" "minio_admin_password" {
  length  = 32
  special = false
}
variable "domain" {
  type        = string
  description = "The domain to use for the service."
}
variable "mounts" {
  type        = map(string)
  default     = {}
  description = "A map of host paths to container paths to mount. The key is the host path, and the value is the container path."
}
module "minio" {
  source       = "../../docker/service"
  stack_name   = "minio"
  service_name = "minio"
  image        = "quay.io/minio/minio:latest"
  command      = ["minio", "server", "/data", ]
  environment_variables = {
    MINIO_ADDRESS              = "0.0.0.0:9000"
    MINIO_CONSOLE_ADDRESS      = "0.0.0.0:9001"
    MINIO_ROOT_USER            = random_pet.minio_admin_user.id
    MINIO_ROOT_PASSWORD        = random_password.minio_admin_password.result
    MINIO_SERVER_URL           = "https://s3.grey.ooo"
    MINIO_BROWSER_REDIRECT_URL = "https://s3.grey.ooo/ui/"
    MINIO_BROWSER_REDIRECT     = true
    MINIO_API_ROOT_ACCESS      = "on"
  }
  mounts                = var.mounts
  networks              = concat(["loadbalancer-traefik"], var.networks)
  placement_constraints = var.placement_constraints
  labels = {
    "traefik.enable" = "true"

    // API redirect
    "traefik.http.routers.minio_api.rule" = "Host(`${var.domain}`) && !PathPrefix(`/ui`)"
    #"traefik.http.routers.minio_api.service"                   = "minio_api"
    "traefik.http.routers.minio_api.entrypoints"               = "websecure"
    "traefik.http.routers.minio_api.tls.certresolver"          = "default"
    "traefik.http.services.minio_api.loadbalancer.server.port" = "9000"

    // UI redirect
    "traefik.http.routers.minio_ui.rule" = "Host(`${var.domain}`) && PathPrefix(`/ui`)"
    #"traefik.http.routers.minio_ui.service"                   = "minio_ui"
    "traefik.http.routers.minio_ui.entrypoints"               = "websecure"
    "traefik.http.routers.minio_ui.tls.certresolver"          = "default"
    "traefik.http.services.minio_ui.loadbalancer.server.port" = "9001"
  }
}

output "minio" {
  value = {
    endpoint = "https://${var.domain}/ui/"
    auth = {
      username = module.minio.docker_service.task_spec[0].container_spec[0].env.MINIO_ROOT_USER
      password = nonsensitive(module.minio.docker_service.task_spec[0].container_spec[0].env.MINIO_ROOT_PASSWORD)
    }
  }
}