resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_name_prefix
  tags          = local.tags
}

