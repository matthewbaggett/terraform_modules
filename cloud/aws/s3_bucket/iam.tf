resource "aws_iam_user" "db_storage" {
  for_each = toset(var.users)
  name     = each.value
}

resource "aws_iam_user_policy" "db_storage" {
  for_each = toset(var.users)
  name     = "s3_policy_${each.value}_to_${aws_s3_bucket.bucket.bucket}"
  user     = aws_iam_user.db_storage[each.key].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}
resource "aws_iam_access_key" "db_storage" {
  for_each = toset(var.users)
  user     = aws_iam_user.db_storage[each.key].name
}
