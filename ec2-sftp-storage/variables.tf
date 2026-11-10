variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Existing public subnet ID"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Your public IP address in CIDR notation"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ebs_size" {
  description = "Dedicated SFTP EBS volume size in GiB"
  type        = number
  default     = 100
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
  default     = "SFTP-Ubuntu-Server"
}