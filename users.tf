############################################
# AWS Transfer Family Users
############################################

resource "aws_transfer_user" "users" {

  for_each = var.users

  server_id = aws_transfer_server.this.id

  user_name = each.key

  role = aws_iam_role.transfer.arn

  home_directory_type = "LOGICAL"

  home_directory_mappings {

    entry = "/"

    target = "/${aws_s3_bucket.sftp.bucket}/${each.value.home_directory}"

  }

  policy = data.aws_iam_policy_document.user_policy[each.key].json

  tags = {
    Name       = each.key
    Department = each.value.department
  }
}

############################################
# SSH Public Keys
############################################

resource "aws_transfer_ssh_key" "users" {
  for_each = var.users

  server_id = aws_transfer_server.this.id
  user_name = aws_transfer_user.users[each.key].user_name
  body      = file("${path.module}/keys/${each.key}.pub")
}
