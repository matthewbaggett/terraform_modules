resource "random_pet" "persona" {
  length    = 2
  separator = " "
  keepers = {
    user_data = sha1(local.user_data)
  }
}
