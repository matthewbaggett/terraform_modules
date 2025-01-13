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
  ip_protocol                  = "tcp"
  from_port                    = 2049
  to_port                      = 2049
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = data.aws_security_group.origin.id
  tags = merge(local.tags, {
    Name = "NFS/EFS Egress"
  })
}
resource "aws_vpc_security_group_ingress_rule" "ping" {
  ip_protocol                  = "icmp"
  from_port                    = 0
  to_port                      = 0
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = data.aws_security_group.origin.id
  tags = merge(local.tags, {
    Name = "Ping"
  })
}