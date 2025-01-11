module "efs_file_system" {
  source                   = "../../cloud/aws/efs_file_system"
  volume_name              = local.volume_name
  users                    = local.users
  tags                     = merge(var.tags, { Name = local.display_name_ascii }, coalesce(var.application.application_tag, {}))
  ia_lifecycle_policy      = var.ia_lifecycle_policy
  security_group_ids       = var.security_group_ids
  application              = var.application
  origin_security_group_id = var.origin_security_group_id
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
}
