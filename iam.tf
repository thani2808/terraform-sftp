data "aws_iam_policy_document" "assume" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {

      type = "Service"

      identifiers = [
        "transfer.amazonaws.com"
      ]

    }

  }

}

resource "aws_iam_role" "transfer" {

  name = "TransferFamilyRole"

  assume_role_policy = data.aws_iam_policy_document.assume.json

}

resource "aws_iam_role_policy" "transfer" {

  role = aws_iam_role.transfer.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "s3:*"
        ]

        Resource = [
          aws_s3_bucket.sftp.arn,
          "${aws_s3_bucket.sftp.arn}/*"
        ]
      }

    ]
  })
}