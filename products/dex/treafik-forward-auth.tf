resource "random_password" "forward_auth_secret" {
  length = 32
  special = false
}
module "forward_auth" {
  source = "../../docker/service"
  stack_name = var.stack_name
  service_name = "forward-auth"
    image = "thomseddon/traefik-forward-auth"
  traefik = {
    port = 4181
  }
  labels = {
    "traefik.http.middlewares.forward-auth.forwardauth.address"             = "http://forward-auth:4181"
    "traefik.http.middlewares.forward-auth.forwardauth.authResponseHeaders" = "X-Forwarded-User"
  }
  environment_variables = {
    SECRET= random_password.forward_auth_secret.result
    INSECURE_COOKIE=var.traefik.ssl ? "false" : "true"
  }
}