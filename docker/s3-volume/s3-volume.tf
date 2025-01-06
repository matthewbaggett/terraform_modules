locals {
  # Sanitise the volume name - strip non-alphanumeric characters and replace spaces and underscores with hyphens
  volume_name = replace(replace(replace(lower(var.volume_name), "[^a-z0-9]", ""), "[ _]", "-"), "--", "-")
  alias       = "s3fs-${local.volume_name}"
  iam_user    = "${var.stack_name}-s3fs-${local.volume_name}"
  bucket_name = var.bucket_name == null ? "${local.volume_name}-bucket" : var.bucket_name
  access_key  = module.bucket.users[local.iam_user].access_key
  secret_key  = module.bucket.users[local.iam_user].secret_key
}
module "swarm_exec" {
  source       = "../../docker/swarm-exec"
  command      = "docker plugin install --alias ${local.alias} ${var.image_s3_plugin} --grant-all-permissions --disable AWSACCESSKEYID=${local.access_key} AWSSECRETACCESSKEY=${local.secret_key} DEFAULT_S3FSOPTS='allow_other,uid=1000,gid=1000,nomultipart'; docker plugin enable ${local.alias}"
  stack_name   = var.stack_name
  service_name = "s3fs-volume-plugin-installer"
}
module "bucket" {
  source             = "../../cloud/aws/s3_bucket"
  bucket_name_prefix = local.bucket_name
  users              = [local.iam_user]
  tags               = merge(var.tags, { Name = local.bucket_name }, coalesce(var.application.application_tag, {}))
}

module "volume" {
  depends_on  = [module.bucket, module.swarm_exec]
  source      = "../../docker/volume"
  stack_name  = var.stack_name
  volume_name = "${module.bucket.bucket}/${var.subdir}"
  driver      = local.alias
  driver_opts = {
    "s3fsopts" = "nomultipart,use_path_request_style"
  }
}
output "volume" {
  value = module.volume.volume
}