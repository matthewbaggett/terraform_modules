resource "aws_iam_user" "db_storage" {
  for_each = toset(var.users)
  name     = each.value
}
data "aws_iam_policy_document" "db_storage" {
  for_each = toset(var.users)
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_user_policy" "db_storage" {
  for_each = toset(var.users)
  name     = "s3_policy_${each.value}_to_${aws_s3_bucket.bucket.bucket}"
  user     = aws_iam_user.db_storage[each.key].name
  policy   = data.aws_iam_policy_document.db_storage[each.key].json
}
resource "aws_iam_access_key" "db_storage" {
  for_each = toset(var.users)
  user     = aws_iam_user.db_storage[each.key].name
}
