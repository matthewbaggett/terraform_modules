module "traefik_hello" {
  count                 = var.hello_service_domain != null ? 1 : 0
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "hello"
  image                 = "nginxdemos/hello:plain-text"
  parallelism           = 3
  placement_constraints = var.placement_constraints
  networks              = [module.traefik_network, ]
  traefik = {
    domain           = var.hello_service_domain
    port             = 80
    ssl              = var.enable_ssl
    non-ssl          = var.enable_non_ssl
    basic-auth-users = var.hello_service_enable_basic_auth ? ["hello"] : []
  }
  healthcheck_interval     = "5s"
  healthcheck_timeout      = "2s"
  healthcheck_start_period = "5s"
}
output "hello_service" {
  value = module.traefik_hello
}