# "timestamp" template function replacement
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name = "packer-kali-linux-${local.timestamp}"
}

source "amazon-ebs" "kali" {
  access_key    = var.aws_access_key
  ami_name      = local.ami_name
  instance_type = var.instance_type

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    encrypted             = true
    kms_key_id            = var.kms_key_id_or_alias
    volume_size           = var.disk_size
  }

  region     = var.aws_region
  secret_key = var.aws_secret_key

  source_ami_filter {
    filters = {
      name                = "kali-linux-${var.kali_distro_version}*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }

  ssh_interface = "public_ip"
  ssh_username  = "kali"
  tags = {
    Base_AMI      = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }
}

build {
  sources = ["source.amazon-ebs.kali"]

  provisioner "shell" {
    inline = [
      "sleep 10",
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-apt python3-pip python3-wheel",
    ]
  }
  provisioner "ansible" {
    extra_arguments = ["-e", "ansible_python_interpreter=/usr/bin/python3", "--skip-tags", "skip"]
    galaxy_file     = "kali/ansible/requirements.yml"
    host_alias      = "kali"
    playbook_file   = "kali/ansible/playbook.yml"
    user            = "kali"
  }
  provisioner "shell" {
    expect_disconnect = true
    inline            = ["sudo systemctl reboot"]
  }
  provisioner "shell" {
    inline = ["echo 'System rebooted, done provisioning'"]
  }
}
