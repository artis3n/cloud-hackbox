variable "kali_instance_type" {
  type        = string
  description = "The EC2 instance size to use for the Kali server."
  default     = "t2.medium"
}

variable "kali_volume_size" {
  type        = number
  description = "The volume size for the Kali EC2 instance, GiB."
  default     = 25
}

variable "kali_pubkey" {
  type        = string
  description = "The public key to a private key under your control. You will SSH onto the server using this keypair."
}

variable "kali_spot_type" {
  type        = string
  description = "Whether to launch the Kali spot instance as a 'persistent' request or a 'one-time' request."
  default     = "one-time"
}

variable "ssh_cidr_range" {
  type        = string
  description = "The CIDR range to allow SSH access from to your provisioned server. Can be a single IP address or a full CIDR range."
}

variable "metadata_enabled" {
  type        = string
  description = "Whether EC2 instance medata is enabled. 'enabled' or 'disabled'. Use 'metadat_tokens' to decide between v1 or v2 of instance metadata."
  default     = "enabled"
}

variable "metadata_tokens" {
  type        = string
  description = "Whether EC2 instance metadata is v1 or v2. 'required' means v2. 'optional' means v1. Use 'metadata_enabled' to disable instance metadata alltogether."
  default     = "required"
}

variable "metadata_hop_limit" {
  type        = number
  description = "The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. It is recommended to leave this at '1'."
  default     = 1
}

variable "ebs_kms_key" {
  type        = string
  description = "KMS key alias to use for KMS key data source. Defaults to the default AWS-managed EBS key."
  default     = "aws/ebs"
}

variable "vpc_az" {
  type        = string
  description = "Availability zone in the default VPC to create resources."
  default     = "us-east-1a"
}
