variable "kali_distro_version" {
  type    = number
  default = 2021.4
}

#variable "hcp_packer_bucket_name" {
#  type = string
#  description = "https://learn.hashicorp.com/tutorials/packer/hcp-push-image-metadata?in=packer/hcp-get-started"
#  default = "kali-hackbox-aws"
#}

#variable "hcp_packer_description" {
#  type = string
#  default = "Kali Linux AMI with extra juice."
#}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type      = string
  default = env("AWS_ACCESS_KEY_ID")
  sensitive = true
}

variable "aws_secret_key" {
  type    = string
  sensitive = true
  default = env("AWS_SECRET_ACCESS_KEY")
}

variable "aws_session_token" {
  type = string
  sensitive = true
  default = env("AWS_SESSION_TOKEN")
}

variable "disk_size" {
  type    = number
  default = 25
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "kms_key_id_or_alias" {
  type    = string
  default = "alias/aws/ebs"
}
