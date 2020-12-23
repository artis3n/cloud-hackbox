# cloud-hackbox

A repository to build and provision custom pentest resources in AWS.

![CI](https://github.com/artis3n/cloud-hackbox/workflows/CI/badge.svg)
![Build](https://github.com/artis3n/cloud-hackbox/workflows/Build/badge.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/artis3n/cloud-hackbox)
![GitHub](https://img.shields.io/github/license/artis3n/cloud-hackbox)
[![GitHub followers](https://img.shields.io/github/followers/artis3n?style=social)](https://github.com/artis3n/)
[![Twitter Follow](https://img.shields.io/twitter/follow/artis3n?style=social)](https://twitter.com/Artis3n)

<img src="docs/kali-packer.gif" width="45%" height="45%" /> <img src="docs/kali-terraform.gif" width="45%" height="45%" />

Supported hackboxes:

- Kali Linux

Additional desired hackboxes:

- ParrotOS

## Setup

```bash
pip install pipenv
# Install Packer, Terraform and AWS CLI as per their documentation
# Optionally,
make install-base
make install-aws

# Then
make install

# If you want to run Molecule tests
pipenv install --dev

# Set your AWS credentials
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
# If you have default or ephemeral credentials saved in ~/.aws/credentials you can forego these env vars
```

Then choose a hackbox and follow the instructions to build and provision it.

## Kali Linux AMI

Packer file: `kali/kali-ami.json`

Builds a Kali Linux AMI with the following:

- Updates all packages on the system
- Installs and configures a number of frequently used packages (`kali-linux-default` plus some others)
  - See the [full list](kali/ansible/variables.yml).

This AMI also pre-configures [UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04).
The following UFW rules are pre-configured:

- deny all incoming
- allow all outgoing
- enable ssh on tcp/22 with brute force mitigation (`ufw limit`)
- allow incoming on tcp/80, tcp/443
- allow incoming on tcp/53, udp/53
- allow incoming on tcp/4000-4999
- deny incoming on tcp/5901
- deny incoming on tcp/5432

Ports 80, 443, 53, and 4000-4999 are left open on UFW to enable reverse shells from targets.
This includes Metasploit's defaults in the 4xxx range.
Ensure your AWS Security Group allows incoming traffic on the ports you use for these listeners.

`tcp/5901` is blocked as VNC is served from the server, however VNC does not communicate over a secure channel.
To connect to the VNC server, you must run a SSH local port forward to the remote `5901` port.

`tcp/5432` is blocked as the Postgres database should not be exposed beyond localhost.

You can add additional ports as you desire with `ufw allow <num>`, however you will also need to update the security group for your instance or modify the Terraform to accomplish the same.

### Usage

You have to first subscribe to the Kali Linux marketplace AMI by navigating to <https://aws.amazon.com/marketplace/pp/B08LL91KKB> and selecting "Continue to Subscribe."
Once this is completed once, your account has access to the marketplace AMI and can follow the instructions below.

```bash
make validate  # pipenv run packer validate
make build  # pipenv run packer build. Will take 30-50 minutes to finish AMI creation.

# If you want to customize the AMI creation:
pipenv run packer build \
  -var ami_name="custom-ami-name" \
  -var kali_distro_version="2020" \
  -var aws_region="us-east-1" \
  -var instance_type="t3.medium" \
  -var kms_key_id_or_alias="alias/aws/ebs" \
  kali/kali-ami.json
```

Once you have an AMI created, you can have an AWS instance available anytime with 1 minute and 1 command:

```bash
make provision
```

You will need to customize the Terraform Cloud state backend [here](kali/terraform/main.tf). This is free and can be found [here](https://app.terraform.io).

Details about the Terraform provision and optional variables to customize can be found in [the README](kali/terraform/README.md) in `kali/terraform`.

When you no longer need the infrastructure, clean it up with:

```bash
make destroy
```

Start VNC and connect to the server graphically:

```bash
ssh -i <private-key.pem> -L 5901:localhost:5901 kali@<instance ip>
```
Then, start a VNC client like [Remmina](https://remmina.org/how-to-install-remmina/) and use the server address `localhost:1`.
Enter the VNC password `goodhacks`.
The quality/speed isn't amazing, but it suffices for occasional graphical usage.

#### Packer Variables

##### Environment variables

**`AWS_ACCESS_KEY_ID`**

Environment variable for your AWS access key ID.
This can be left unset if you have sufficiently privileged default credentials in `~/.aws/credentials`.
Otherwise **required**.

**`AWS_SECRET_ACCESS_KEY`**

Environment variable for your AWS secret access key.
This can be left unset if you have sufficiently privileged default credentials in `~/.aws/credentials`.
Otherwise **required**.

##### Command-line variables

**`ami_name`**

The name to assign to the generated AMI.
The default is `packer-kali-linux-{{timestamp}}`.

**`kali_distro_version`**

The version of the [Kali Linux Marketplace AMI](https://aws.amazon.com/marketplace/pp/B08LL91KKB) to build from.
The default is `2020`.

**`disk_size`**

The AMI's default EBS volume size in GB and the size to use when generating the AMI.
The default is `25`.
The minimum required by the root AMI is `12`, but this is unlikely to be sufficient for the full set of Kali tools and the GUI added to the system.
See the below output of `df` on this custom AMI post-creation.

```bash
└─$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            2.0G     0  2.0G   0% /dev
tmpfs           394M  1.0M  393M   1% /run
/dev/xvda1       25G   15G  8.5G  64% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           4.0M     0  4.0M   0% /sys/fs/cgroup
/dev/xvda15     124M  262K  124M   1% /boot/efi
tmpfs           394M   52K  394M   1% /run/user/0
tmpfs           394M   56K  394M   1% /run/user/130
tmpfs           394M   52K  394M   1% /run/user/1000
```

**`instance_type`**

The instance type to use when generating the AMI.
The default is `t3.medium`.
Must be one of the instance types supported by the base [Kali Linux AMI](https://aws.amazon.com/marketplace/pp/B08LL91KKB).

**`aws_region`**

The AWS region into which to create the AMI.
Default is `us-east-1`.

**`kms_key_id_or_alias`**

By default, the generated AMI is encrypted with the Amazon-managed `aws/ebs` KMS key.
You can instead provide a custom KMS key, either by key ID or by alias.

## Parrot OS AMI

Packer file: `parrot-ova.json`

Since ParrotOS is not on the AWS Marketplace, we need to build this AMI by first creating an ISO image, converting it into an OVA file, and then importing it into AWS EC2.

However, ParrotOS uses a modern Debian kernal and AWS EC2 VM Import support for Debian ends at Debian 8. So, this is likely impossible at this time.
