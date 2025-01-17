module "socat" {
  source                = "github.com/matthewbaggett/terraform_modules//docker/service"
  stack_name            = var.stack_name
  service_name          = var.service_name
  image                 = "alpine/socat:latest"
  command               = ["socat", "tcp-listen:${var.target.port},fork,reuseaddr", "tcp-connect:${var.target.host}:${var.target.port}"]
  traefik               = merge({ port = var.target.port }, var.traefik)
  converge_enable       = false
  placement_constraints = var.placement_constraints
}
