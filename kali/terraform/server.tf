resource "aws_spot_instance_request" "kali" {
    ami = data.aws_ami.kali.id
    spot_type = var.kali_spot_type
    instance_type = var.kali_instance_type
    key_name = aws_key_pair.kali.id

    security_groups = [
        aws_security_group.ssh_from_home.id
    ]

    root_block_device {
        volume_size = var.kali_volume_size
        encrypted = true
        kms_key_id = data.aws_kms_key.default_ebs.arn
    }

    metadata_options {
        http_endpoint = var.metadata_enabled
        http_tokens = var.metadata_tokens
        http_put_response_hop_limit = var.metadata_hop_limit
    }
}

resource "aws_security_group" "ssh_from_home" {
    name = "SSH from CIDR"
    description = "allow ssh from a cidr range"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.ssh_cidr_range]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "kali" {
    key_name = "cloud-hackbox-kali"
    public_key = var.kali_pubkey
}

data "aws_ami" "kali" {
    owners = ["self"]
    most_recent = true
    filter {
        name = "name"
        values = ["packer-kali-linux-*"]
    }
}

data "aws_kms_key" "default_ebs" {
    key_id = "alias/${var.ebs_kms_key}"
}
