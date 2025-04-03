locals {
  user_data        = data.cloudinit_config.config.rendered
  user_data_base64 = base64encode(data.cloudinit_config.config.rendered)
  hash             = sha1(data.cloudinit_config.config.rendered)
  hash_short       = substr(sha1(data.cloudinit_config.config.rendered), 0, 7)
}

output "persona" {
  value = random_pet.persona.id
}
output "user_data" {
  value = local.user_data
}
output "user_data_base64" {
  value = sensitive(local.user_data_base64) # Sensitive to avoid making a wall of noise.
}
output "hash" {
  value = local.hash
}
output "hash_short" {
  value = local.hash_short
}
