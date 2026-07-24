##########################################
# IAM Trust Policy for AWS Transfer Family
##########################################
data "aws_iam_policy_document" "transfer_assume" {

  statement {

    sid    = "TransferAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      type = "Service"

      identifiers = [
        "transfer.amazonaws.com"
      ]
    }
  }
}

##########################################
# IAM Role
##########################################
resource "aws_iam_role" "transfer" {

  name               = "TransferFamilyRole"
  assume_role_policy = data.aws_iam_policy_document.transfer_assume.json

  tags = {
    Name = "TransferFamilyRole"
  }
}

##########################################
# IAM Policy for S3 Access
##########################################
resource "aws_iam_role_policy" "transfer" {

  name = "TransferFamilyS3Policy"

  role = aws_iam_role.transfer.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      ###################################################
      # Bucket Permissions
      ###################################################
      {
        Sid    = "BucketAccess"
        Effect = "Allow"

        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.sftp.arn
        ]
      },

      ###################################################
      # Object Permissions
      ###################################################
      {
        Sid    = "ObjectAccess"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "${aws_s3_bucket.sftp.arn}/*"
        ]
      }

    ]

  })

}
