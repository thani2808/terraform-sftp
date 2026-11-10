# Ubuntu 22.04 LTS AMI from Canonical
data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Get Availability Zone of the selected subnet
data "aws_subnet" "selected" {
  id = var.subnet_id
}

# Security Group
resource "aws_security_group" "sftp_ec2" {
  name        = "sftp-ec2-security-group"
  description = "SSH access to SFTP EC2 server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from approved IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Outbound internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SFTP-EC2-SG"
  }
}

# Dedicated encrypted EBS volume
resource "aws_ebs_volume" "sftp_data" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.ebs_size
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "SFTP-Dedicated-Storage"
  }
}

# Ubuntu EC2 instance
resource "aws_instance" "sftp_server" {
  ami                    = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sftp_ec2.id]
  key_name               = var.key_name

  # Elastic IP will provide public IPv4 connectivity
  associate_public_ip_address = false

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

  user_data = templatefile("${path.module}/templates/mount-ebs.sh.tpl", {
    volume_id = aws_ebs_volume.sftp_data.id
  })

  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
    OS   = "Ubuntu-22.04-LTS"
  }
}

# Attach the dedicated EBS volume
resource "aws_volume_attachment" "sftp_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.sftp_data.id
  instance_id = aws_instance.sftp_server.id

  force_detach = false
}

# Allocate Elastic IP
resource "aws_eip" "sftp_eip" {
  domain = "vpc"

  tags = {
    Name = "SFTP-EC2-Elastic-IP"
  }
}

# Associate Elastic IP with EC2
resource "aws_eip_association" "sftp_eip" {
  instance_id   = aws_instance.sftp_server.id
  allocation_id = aws_eip.sftp_eip.id
}
