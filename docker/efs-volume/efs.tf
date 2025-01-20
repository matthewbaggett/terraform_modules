module "efs_file_system" {
  source                   = "../../cloud/aws/efs_file_system"
  volume_name              = local.volume_name
  users                    = local.users
  tags                     = merge(var.tags, { Name = local.display_name_ascii }, coalesce(var.application.application_tag, {}))
  ia_lifecycle_policy      = var.ia_lifecycle_policy
  archive_lifecycle_policy = var.archive_lifecycle_policy
  application              = var.application
  origin_security_group_id = var.origin_security_group_id
  vpc_id                   = data.aws_vpc.vpc.id
  subnet_ids               = var.subnet_ids
}
data "aws_vpc" "vpc" {
  id = var.vpc_id
  lifecycle {
    postcondition {
      condition     = self.enable_dns_hostnames == true
      error_message = "VPC must have DNS hostnames enabled"
    }
    postcondition {
      condition     = self.enable_dns_support == true
      error_message = "VPC must have DNS support enabled"
    }
  }
}
