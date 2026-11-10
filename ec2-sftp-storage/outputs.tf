output "instance_id" {
  value = aws_instance.sftp_server.id
}

output "instance_public_ip" {
  value = aws_eip.sftp_eip.public_ip
}

output "instance_type" {
  value = aws_instance.sftp_server.instance_type
}

output "ubuntu_ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID"
  value       = nonsensitive(aws_instance.sftp_server.ami)
}

output "root_volume_size" {
  value = aws_instance.sftp_server.root_block_device[0].volume_size
}

output "dedicated_ebs_volume_id" {
  value = aws_ebs_volume.sftp_data.id
}

output "dedicated_ebs_volume_size" {
  value = aws_ebs_volume.sftp_data.size
}

output "dedicated_ebs_device" {
  value = aws_volume_attachment.sftp_data.device_name
}

output "mount_point" {
  value = "/sftp-data"
}