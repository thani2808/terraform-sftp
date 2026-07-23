variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "company-sftp-storage-demo-123456"
}

variable "users" {

  type = map(string)

  default = {

    user1 = "keys/user1.pub"
    user2 = "keys/user2.pub"
    user3 = "keys/user3.pub"

  }

}