module "docker_socket_proxy" {
  source     = "github.com/matthewbaggett/terraform_modules//docker/socket-proxy"
  stack_name = var.stack_name
  enable_all = true
}