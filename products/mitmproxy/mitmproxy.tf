module "mitmproxy" {
  source       = "../../docker/service"
  stack_name   = var.stack_name
  service_name = "mitmproxy"
  networks     = var.networks
  image        = "ghcr.io/benzine-framework/mitmproxy"
  command = [
    "mitmweb",
    "--web-host", "0.0.0.0",
    "--web-port", "8081",
    #"--listen-host", "0.0.0.0",
    #"--listen-port", "8080",
    #"--ssl-insecure",
  ]
  healthcheck           = ["CMD-SHELL", " curl -I http://localhost:8081 || exit 1"]
  placement_constraints = var.placement_constraints
  traefik               = var.traefik
  ports = [
    {
      protocol  = "tcp"
      container = 8080
      host      = 4080
    },
    {
      protocol  = "tcp"
      container = 8081
      host      = 4081
    }
  ]
}