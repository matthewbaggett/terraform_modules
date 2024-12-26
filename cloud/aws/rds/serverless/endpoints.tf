resource "aws_rds_cluster_endpoint" "endpoint" {
  depends_on                  = [aws_rds_cluster_instance.instance]
  for_each                    = { "write" = "ANY", "read" = "READER" }
  cluster_endpoint_identifier = join("-", [local.sanitised_name, each.key, "endpoint"])
  cluster_identifier          = aws_rds_cluster.cluster.id
  custom_endpoint_type        = each.value

  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}
