module "portainer_network" {
  source       = "github.com/matthewbaggett/terraform_modules//docker/network"
  stack_name   = var.stack_name
  network_name = "portainer"
}