module "volume" {
  source               = "../../docker/volume"
  stack_name           = var.stack_name
  volume_name          = local.volume_name
  volume_name_explicit = true
  driver               = "local"
  driver_opts = {
    "type"   = "nfs"
    "o"      = "addr=${module.efs_file_system.dns_name},rw,nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2"
    "device" = ":/"
  }
}
output "volume" {
  value = module.volume.volume
}