locals {
  # @todo MB: fix volume name its janky
  volume_name        = lower(trim(replace(local.display_name_ascii, " ", "-"), "-"))
  display_name       = trimspace(var.volume_name)
  display_name_ascii = replace(local.display_name, "/[^a-zA-Z0-9_ ]/", "")
  tags               = merge(var.application.application_tag, var.tags)
  security_group_ids = distinct(concat(var.security_group_ids, [aws_security_group.efs.id]))
  efs_tags = merge(local.tags, {
    Name = local.volume_name
  })
  efs_ap_tags = merge(local.tags, {
    Name = "${local.display_name_ascii} Access Point"
  })
}