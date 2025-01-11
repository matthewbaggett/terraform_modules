module "volume" {
  #depends_on           = [docker_plugin.efs, ]
  source               = "../../docker/volume"
  stack_name           = var.stack_name
  volume_name          = local.volume_name
  volume_name_explicit = true
  #driver               = local.alias
}
output "volume" {
  value = module.volume.volume
}