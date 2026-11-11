
output "sftp_instance_id" {
  description = "SFTP EC2 instance ID"
  value       = aws_instance.sftp_server.id
}

output "sftp_public_ip" {
  description = "SFTP EC2 public IP"
  value       = aws_instance.sftp_server.public_ip
}

output "sftp_private_ip" {
  description = "SFTP EC2 private IP"
  value       = aws_instance.sftp_server.private_ip
}

output "sftp_security_group_ids" {
  description = "Security Groups attached to SFTP EC2"
  value       = aws_instance.sftp_server.vpc_security_group_ids
}

output "sftp_ebs_volume_id" {
  description = "Dedicated SFTP data EBS volume ID"
  value       = aws_ebs_volume.sftp_data.id
}

output "sftp_availability_zone" {
  description = "EC2 availability zone"
  value       = aws_instance.sftp_server.availability_zone
}

output "sftp_vpc_id" {
  description = "Existing VPC ID"
  value       = var.vpc_id
}

output "sftp_internet_gateway_id" {
  description = "Existing Internet Gateway ID"
  value       = data.aws_internet_gateway.existing.id
}

output "sftp_route_table_id" {
  description = "Existing main route table ID"
  value       = data.aws_route_table.existing.id
}

output "sftp_subnet_id" {
  description = "Existing public subnet ID"
  value       = var.subnet_id
}
