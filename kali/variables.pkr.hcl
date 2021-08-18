variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type      = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
  sensitive = true
}

variable "aws_secret_key" {
  type    = string
  sensitive = true
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "disk_size" {
  type    = number
  default = 25
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "kali_distro_version" {
  type    = number
  default = 2020
}

variable "kms_key_id_or_alias" {
  type    = string
  default = "alias/aws/ebs"
}
