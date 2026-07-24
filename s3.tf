############################################
# S3 Bucket
############################################

resource "aws_s3_bucket" "sftp" {

  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name = var.bucket_name
  }

}

############################################
# Enable Versioning
############################################

resource "aws_s3_bucket_versioning" "sftp" {

  bucket = aws_s3_bucket.sftp.id

  versioning_configuration {
    status = "Enabled"
  }

}

############################################
# Block Public Access
############################################

resource "aws_s3_bucket_public_access_block" "sftp" {

  bucket = aws_s3_bucket.sftp.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

}

############################################
# User Home Folder
############################################

resource "aws_s3_object" "home" {

  for_each = var.users

  bucket = aws_s3_bucket.sftp.id

  key = "${each.value.home_directory}/"

  content = ""

}

############################################
# Upload Folder
############################################

resource "aws_s3_object" "upload" {

  for_each = var.users

  bucket = aws_s3_bucket.sftp.id

  key = "${each.value.home_directory}/upload/"

  content = ""

}

############################################
# Download Folder
############################################

resource "aws_s3_object" "download" {

  for_each = var.users

  bucket = aws_s3_bucket.sftp.id

  key = "${each.value.home_directory}/download/"

  content = ""

}