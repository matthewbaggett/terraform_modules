locals {
  # Sanitise the volume name - strip non-alphanumeric characters and replace spaces and underscores with hyphens
  volume_name = replace(replace(replace(lower(var.volume_name), "[^a-z0-9]", ""), "[ _]", "-"), "--", "-")
  alias       = "s3fs-${local.volume_name}"
  iam_user    = "${var.stack_name}-s3fs-${local.volume_name}"
  bucket_name = var.bucket_name == null ? "${local.volume_name}-bucket" : var.bucket_name
  access_key  = module.bucket.users[local.iam_user].access_key
  secret_key  = module.bucket.users[local.iam_user].secret_key
}
resource "docker_plugin" "s3fs" {
  name    = var.image_s3_plugin
  alias   = local.alias
  enabled = true
  grant_permissions {
    name  = "network"
    value = ["host"]
  }
  grant_permissions {
    name  = "mount"
    value = ["/dev"]
  }
  grant_permissions {
    name  = "allow-all-devices"
    value = ["true"]
  }
  grant_permissions {
    name  = "capabilities"
    value = ["CAP_SYS_ADMIN"]
  }
  env = [
    "REXRAY_LOGLEVEL=warn",
    "S3FS_ACCESSKEY=${local.access_key}",
    "S3FS_SECRETKEY=${local.secret_key}",
  ]
  lifecycle {
    create_before_destroy = false
  }
}
module "bucket" {
  source             = "../../cloud/aws/s3_bucket"
  bucket_name_prefix = local.bucket_name
  users              = [local.iam_user]
  tags               = merge(var.tags, { Name = local.bucket_name }, coalesce(var.application.application_tag, {}))
}
module "volume" {
  depends_on           = [docker_plugin.s3fs, module.bucket]
  source               = "../../docker/volume"
  stack_name           = var.stack_name
  volume_name          = module.bucket.bucket
  volume_name_explicit = true
  driver               = local.alias
}
output "volume" {
  value = module.volume.volume
}