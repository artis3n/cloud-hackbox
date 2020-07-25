# cloud-hackbox

A repository to build and provision custom pentest resources in AWS.

Supported hackboxes:

- Kali Linux

Additional desired hackboxes:

- ParrotOS

## Setup

```bash
pip install pipenv
# Installs Terraform, Packer, and Pipenv dependencies (e.g. Ansible)
make install

# If you want to run Molecule tests
pipenv install --dev

# Set your AWS credentials
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
# If you have default or ephemeral credentials saved in ~/.aws/credentials you can forego these env vars
```

Then choose a hackbox and follow the instructions to build and provision it.

## Hackboxes

### Kali Linux AMI

Packer file: `kali/kali-ami.json`

Builds a Kali Linux AMI with the following:

- Updates all packages on the system
- Installs and configures a number of frequently used packages
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

#### Usage

```bash
make validate  # pipenv run packer validate
make build  # pipenv run packer build

# If you want to customize the AMI creation:
pipenv run packer build \
  -var ami_name="custom-ami-name" \
  -var kali_distro_version="2020" \
  -var aws_region="us-east-1" \
  -var instance_type="t2.medium" \
  kali/kali-ami.json
```

Once you have an AMI created, you can have an AWS instance available anytime with 1 minute and 1 command:

```bash
make provision
```

You will need to customize the Terraform Cloud state backend [here](kali/terraform/main.tf). This is free and can be found [here](https://app.terraform.io).

Details about the Terraform provision and optional variables to customize can be found in [the README](kali/terraform/README.md) in `kali/terraform`.

##### Packer Variables

###### Environment variables

**`AWS_ACCESS_KEY_ID`**

Environment variable for your AWS access key ID.
This can be left unset if you have sufficiently privileged default credentials in `~/.aws/credentials`.
Otherwise **required**.

**`AWS_SECRET_ACCESS_KEY`**

Environment variable for your AWS secret access key.
This can be left unset if you have sufficiently privileged default credentials in `~/.aws/credentials`.
Otherwise **required**.

###### Command-line variables

**`ami_name`**

The name to assign to the generated AMI.
The default is `packer-kali-linux-{{timestamp}}`.

**`kali_distro_version`**

The version of the [Kali Linux Marketplace AMI](https://aws.amazon.com/marketplace/pp/B01M26MMTT) to build from.
The default is `2020`.

**`disk_size`**

The AMI's default EBS volume size in GB and the size to use when generating the AMI.
The default (and mininum) is `25`.

**`instance_type`**

The instance type to use when generating the AMI.
The default is `t2.medium`.
Must be one of the instance types supported by the base [Kali Linux AMI](https://aws.amazon.com/marketplace/pp/B01M26MMTT).

**`aws_region`**

The AWS region into which to create the AMI.
Default is `us-east-1`.

### Parrot OS AMI

Packer file: `parrot-ova.json`

Since ParrotOS is not on the AWS Marketplace, we need to build this AMI by first creating an ISO image, converting it into an OVA file, and then importing it into AWS EC2.

However, ParrotOS uses a modern Debian kernal and AWS EC2 VM Import support for Debian ends at Debian 8. So, this is likely impossible at this time.
