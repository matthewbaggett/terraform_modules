resource "aws_kms_key" "bucket" {
  description = "Used to encrypt S3 bucket ${aws_s3_bucket.bucket.bucket}"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket.id
      sse_algorithm = "aws:kms"
    }
  }
}