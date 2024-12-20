module "traefik_hello" {
  count                 = var.hello_service_domain != null ? 1 : 0
  source                = "../../docker/service"
  stack_name            = var.stack_name
  service_name          = "hello"
  image                 = "nginxdemos/hello:plain-text"
  parallelism           = 3
  placement_constraints = var.placement_constraints
  networks              = [module.traefik_network, ]
  ports                 = [{ container = 80 }]
  traefik = {
    domain = var.hello_service_domain
    port   = 80
    ssl    = var.enable_ssl
  }
}
output "hello_service" {
  value = module.traefik_hello
}