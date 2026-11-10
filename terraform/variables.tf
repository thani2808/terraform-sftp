
variable "aws_region" {
  description = "AWS region for the SFTP development environment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "sftp-server"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "VPC ID for the SFTP server"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the SFTP server"
  type        = string
}

variable "create_test_security_group" {
  description = "Create a new Security Group for development"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "Existing Security Group IDs for production"
  type        = list(string)
  default     = []
}

variable "allowed_sftp_cidrs" {
  description = "Approved client IP addresses for SFTP access"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "data_volume_size" {
  description = "SFTP data disk size in GB"
  type        = number
  default     = 100
}

variable "data_volume_type" {
  description = "SFTP data disk type"
  type        = string
  default     = "gp3"
}

variable "kms_key_id" {
  description = "Optional customer-managed KMS key ID"
  type        = string
  default     = null
}
