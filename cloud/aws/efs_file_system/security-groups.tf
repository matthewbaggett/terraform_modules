data "aws_vpc" "vpc" {
  id = var.vpc_id
}
data "aws_security_group" "origin" {
  id = var.origin_security_group_id
}
resource "aws_security_group" "efs" {
  name        = "${local.volume_name}-EFS"
  description = "EFS file system for ${local.display_name_ascii}"
  vpc_id      = data.aws_vpc.vpc.id
  tags = merge(local.tags, {
    Name = "${var.volume_name} EFS"
  })
}
resource "aws_vpc_security_group_ingress_rule" "nfs" {
  description                  = "Allow NFS traffic from EFS"
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = data.aws_security_group.origin.id
  tags = merge(local.tags, {
    Name = "NFS/EFS Ingress"
  })
}
resource "aws_vpc_security_group_egress_rule" "nfs" {
  description                  = "Allow NFS traffic to EFS"
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = data.aws_security_group.origin.id
  tags = merge(local.tags, {
    Name = "NFS/EFS Egress"
  })
}
# checkov:skip=CKV_AWS_24: checkov is mis-detecting this as exposing port 22 to 0.0.0.0
# checkov:skip=CKV_AWS_25: checkov is mis-detecting this as exposing port 3389 to 0.0.0.0
# checkov:skip=CKV_AWS_260: checkov is mis-detecting this as exposing port 80 to 0.0.0.0
resource "aws_vpc_security_group_ingress_rule" "ping" {
  description                  = "Allow ping"
  ip_protocol                  = "icmp"
  from_port                    = 0
  to_port                      = 0
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = data.aws_security_group.origin.id
  tags = merge(local.tags, {
    Name = "Ping"
  })
}