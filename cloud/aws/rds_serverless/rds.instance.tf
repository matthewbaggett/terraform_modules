resource "aws_rds_cluster_instance" "instance" {
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  tags = merge(
    var.application.application_tag,
    {}
  )
}