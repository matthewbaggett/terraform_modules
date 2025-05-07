output "smtp_host" {
  value = module.mailcatcher.docker_service.name
}
output "smtp_port" {
  value = 1025
}
output "smtp_username" {
  value = "username"
}
output "smtp_password" {
  value = "password"
}
output "network" {
  value = module.network
}