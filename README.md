# cloud-hackbox

A repository to build and provision custom pentest resources in AWS.

Supported AWS hackboxes:

- Kali Linux

Additional desired AWS hackboxes:

- ParrotOS

## Setup

```bash
pip install pipenv
pipenv install
```

## Hackboxes

### Kali Linux AMI

Packer file: `kali-ami.json`

Builds a Kali Linux AMI with the following:

- Updates all packages on the system
- Installs and configures common packages
  - Metasploit DB initialization
  - [SecLists](https://github.com/danielmiessler/SecLists)

#### Usage

```bash
pipenv shell

packer validate kali/kali-ami.json
packer build kali/kali-ami.json
```

Possible variables:

`AWS_ACCESS_KEY_ID`: Environment variable for your AWS access key ID.
This can be left unset if you have sufficiently privileged default credentials in `~/.aws/credentials`.

`AWS_SECRET_ACCESS_KEY`: Environment variable for your AWS secret access key.
This can be left unset if you have sufficiently privileged default credentials in `~/.aws/credentials`.

### Parrot OS AMI

Packer file: `parrot-ova.json`

Since ParrotOS is not on the AWS Marketplace, we need to build this AMI by first creating an ISO image, converting it into an OVA file, and then importing it into AWS EC2.

However, ParrotOS uses a modern Debian kernal and AWS EC2 VM Import support for Debian ends at Debian 8. So, this is likely impossible at this time.

`kali-ova.json` is a test of the OVA image import process before attempting with `parrot-ova.json`. Kali Linux also uses a Debian kernel unsupported by AWS EC2 VM Import, i.e. something more recent than Debian 8.
