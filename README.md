# cloud-hackbox

A repository to build and provision custom pentest resources in AWS.

Supported hackboxes:

- Kali Linux

Additional desired hackboxes:

- ParrotOS

## Setup

```bash
pip install pipenv
pipenv install

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

Packer file: `kali-ami.json`

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
- allow incoming on tcp/4000-6000

Ports 80, 443, 53, and 4000-6000 are left open on UFW to enable reverse shells from targets.
This includes Metasploit's defaults in the 4xxx range.
Ensure your AWS Security Group allows incoming traffic on the ports you use for these listeners.

#### Usage

```bash
pipenv shell

packer validate kali/kali-ami.json
packer build kali/kali-ami.json

# With optional customizations
packer build \
  -var ami_name="custom-ami-name" \
  -var kali_distro_version="2020" \
  -var aws_region="us-east-1" \
  -var instance_type="t2.medium" \
  kali/kali-ami.json
```

##### Variables

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

The AMI's default EBS volume size and the size to use when generating the AMI.
The default is `25600`, which is 25 GBs.

**`instance_type`**

The instance type to use when generating the AMI.
The default is `t2.medium`.

**`aws_region`**

The AWS region into which to create the AMI.
Default is `us-east-1`.

### Parrot OS AMI

Packer file: `parrot-ova.json`

Since ParrotOS is not on the AWS Marketplace, we need to build this AMI by first creating an ISO image, converting it into an OVA file, and then importing it into AWS EC2.

However, ParrotOS uses a modern Debian kernal and AWS EC2 VM Import support for Debian ends at Debian 8. So, this is likely impossible at this time.

`kali-ova.json` is a test of the OVA image import process before attempting with `parrot-ova.json`. Kali Linux also uses a Debian kernel unsupported by AWS EC2 VM Import, i.e. something more recent than Debian 8.
