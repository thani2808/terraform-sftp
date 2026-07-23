resource "aws_transfer_server" "this" {

  identity_provider_type = "SERVICE_MANAGED"

  endpoint_type = "PUBLIC"

  protocols = [
    "SFTP"
  ]

}