output "postgres" {
  value = module.postgres.endpoint
}
output "auth" {
  value = {
    username = random_pet.user.id
    password = nonsensitive(random_password.password.result)
  }
}