resource "aws_transfer_server" "this" {

  identity_provider_type = "SERVICE_MANAGED"

  protocols = ["SFTP"]

  endpoint_type = "PUBLIC"

  tags = {
    Name = "SFTP-Server"
  }
}