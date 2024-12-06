output "users" {
  value = {
    for user in var.users : user => { name = user, access_key = aws_iam_access_key.db_storage[user].id, secret_key = aws_iam_access_key.db_storage[user].secret }
  }
}
output "bucket" {
  value = aws_s3_bucket.bucket.bucket
}
output "arn" {
  value = aws_s3_bucket.bucket.arn
}
output "region" {
  value = aws_s3_bucket.bucket.region
}
output "endpoint" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}