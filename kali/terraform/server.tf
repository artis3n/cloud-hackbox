resource "aws_instance" "kali" {
  ami           = data.aws_ami.kali.id
  instance_type = var.kali_instance_type
  key_name      = aws_key_pair.kali.id
  subnet_id     = data.aws_subnet.default_vpc_subnet.id

  user_data = file("${path.module}/userdata.sh")

  security_groups = [
    aws_security_group.ssh.id,
    aws_security_group.kali_defaults.id,
  ]

  root_block_device {
    volume_size = var.kali_volume_size
    encrypted   = true
    kms_key_id  = data.aws_kms_key.default_ebs.arn
  }

  metadata_options {
    http_endpoint               = var.metadata_enabled
    http_tokens                 = var.metadata_tokens
    http_put_response_hop_limit = var.metadata_hop_limit
  }
}

resource "aws_security_group" "ssh" {
  name        = "SSH from CIDR"
  description = "allow ssh from a cidr range"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kali_defaults" {
  name        = "Default open ports for Kali usage"
  description = "Opens up a number of ports for incoming traffic to facilitate Kali activities and reverse shells. Pwn away."
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.target_cidr_range]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.target_cidr_range]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.target_cidr_range]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.target_cidr_range]
  }

  ingress {
    from_port   = 4000
    to_port     = 4999
    protocol    = "tcp"
    cidr_blocks = [var.target_cidr_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "kali" {
  key_name   = "cloud-hackbox-kali"
  public_key = var.kali_pubkey
}

data "aws_ami" "kali" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["packer-kali-linux-*"]
  }
}

data "aws_kms_key" "default_ebs" {
  key_id = "alias/${var.ebs_kms_key}"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "default_vpc_subnet" {
  vpc_id            = data.aws_vpc.default_vpc.id
  default_for_az    = true
  availability_zone = var.vpc_az
}
