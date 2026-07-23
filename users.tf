resource "aws_transfer_user" "users" {

  for_each = var.users

  server_id = aws_transfer_server.this.id

  user_name = each.key

  role = aws_iam_role.transfer.arn

  home_directory_type = "LOGICAL"

  home_directory_mappings {

    entry = "/"

    target = "/${aws_s3_bucket.sftp.bucket}/${each.key}"

  }

}

resource "aws_transfer_ssh_key" "keys" {

  for_each = var.users

  server_id = aws_transfer_server.this.id

  user_name = aws_transfer_user.users[each.key].user_name

  body = file(each.value)
}