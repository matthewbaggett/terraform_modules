output "service" {
  value = module.dex
}
output "postgres" {
  value = module.postgres
}

output "users" {
  value = local.staticPasswords
}