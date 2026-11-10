
# Ubuntu 24.04 LTS AMI
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Development Security Group
resource "aws_security_group" "sftp_test_sg" {
  count = var.create_test_security_group ? 1 : 0

  name        = "${var.project_name}-${var.environment}-sg"
  description = "SFTP access for ${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SFTP access from approved client IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_sftp_cidrs
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Select the Security Groups for EC2
locals {
  instance_security_group_ids = var.create_test_security_group ? [
    aws_security_group.sftp_test_sg[0].id
  ] : var.security_group_ids
}

# SFTP EC2 Instance
resource "aws_instance" "sftp_server" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = local.instance_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  lifecycle {
    precondition {
      condition     = length(local.instance_security_group_ids) > 0
      error_message = "At least one Security Group must be attached to the SFTP EC2 instance."
    }
  }
}

# Dedicated 100 GB SFTP data volume
resource "aws_ebs_volume" "sftp_data" {
  availability_zone = aws_instance.sftp_server.availability_zone
  size              = var.data_volume_size
  type              = var.data_volume_type
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-data"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Attach data volume to EC2
resource "aws_volume_attachment" "sftp_data_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.sftp_data.id
  instance_id = aws_instance.sftp_server.id

  force_detach = false
}
