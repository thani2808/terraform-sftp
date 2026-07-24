data "aws_iam_policy_document" "user_policy" {
  for_each = var.users

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.sftp.arn}/${each.value.home_directory}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.sftp.arn
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "${each.value.home_directory}/*"
      ]
    }
  }
}