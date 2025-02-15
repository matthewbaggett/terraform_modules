resource "local_file" "debug" {
  filename = "${path.root}/.debug/aws/s3_bucket/bucket.${aws_s3_bucket.bucket.bucket}.json"
  content = jsonencode({
    bucket_prefix = var.bucket_name_prefix,
    tags          = local.tags,
    endpoint      = aws_s3_bucket.bucket.bucket_domain_name
  })
  file_permission = "0600"
}