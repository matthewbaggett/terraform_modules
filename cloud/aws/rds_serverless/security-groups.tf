resource "aws_security_group" "rds" {
  name        = join("-", [var.instance_name, "rds"])
  description = "RDS Security Group for ${var.instance_name}"
  vpc_id      = data.aws_vpc.current.id
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}
variable "source_security_group_id" {
  type        = string
  description = "The security group ID to allow access to the RDS instance"
}
data "aws_security_group" "source" {
  id = var.source_security_group_id
}
resource "aws_security_group_rule" "sgr" {
  security_group_id        = aws_security_group.rds.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = local.db_tunnel_remote.port
  to_port                  = local.db_tunnel_remote.port
  source_security_group_id = var.source_security_group_id
}