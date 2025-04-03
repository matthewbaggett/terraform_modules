output "admin" {
  value = {
    username = random_pet.admin_user.id
    password = nonsensitive(random_password.admin_password.result)
  }
}