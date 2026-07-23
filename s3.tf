resource "aws_s3_bucket" "sftp" {

  bucket = var.bucket_name

}

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.sftp.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_object" "home" {
  for_each = var.users

  bucket = aws_s3_bucket.sftp.id
  key    = "${each.key}/"
}

resource "aws_s3_object" "upload" {
  for_each = var.users

  bucket = aws_s3_bucket.sftp.id
  key    = "${each.key}/upload/"
}

resource "aws_s3_object" "download" {
  for_each = var.users

  bucket = aws_s3_bucket.sftp.id
  key    = "${each.key}/download/"
}

