variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "aristaconsulting"
}

variable "users" {

  description = "Transfer Family users"

  type = map(object({

    department = string

    home_directory = string

    public_key = string

  }))

}