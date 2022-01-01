<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.kali](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.kali](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.kali_defaults](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.kali](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_kms_key.default_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_subnet.default_vpc_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kali_pubkey"></a> [kali\_pubkey](#input\_kali\_pubkey) | The public key to a private key under your control. You will SSH onto the server using this keypair. | `string` | n/a | yes |
| <a name="input_ebs_kms_key"></a> [ebs\_kms\_key](#input\_ebs\_kms\_key) | KMS key alias to use for KMS key data source. Defaults to the default AWS-managed EBS key. | `string` | `"aws/ebs"` | no |
| <a name="input_kali_instance_type"></a> [kali\_instance\_type](#input\_kali\_instance\_type) | The EC2 instance size to use for the Kali server. | `string` | `"t3.medium"` | no |
| <a name="input_kali_spot_type"></a> [kali\_spot\_type](#input\_kali\_spot\_type) | Whether to launch the Kali spot instance as a 'persistent' request or a 'one-time' request. | `string` | `"one-time"` | no |
| <a name="input_kali_volume_size"></a> [kali\_volume\_size](#input\_kali\_volume\_size) | The volume size for the Kali EC2 instance, GiB. | `number` | `25` | no |
| <a name="input_metadata_enabled"></a> [metadata\_enabled](#input\_metadata\_enabled) | Whether EC2 instance medata is enabled. 'enabled' or 'disabled'. Use 'metadat\_tokens' to decide between v1 or v2 of instance metadata. | `string` | `"enabled"` | no |
| <a name="input_metadata_hop_limit"></a> [metadata\_hop\_limit](#input\_metadata\_hop\_limit) | The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. It is recommended to leave this at '1'. | `number` | `1` | no |
| <a name="input_metadata_tokens"></a> [metadata\_tokens](#input\_metadata\_tokens) | Whether EC2 instance metadata is v1 or v2. 'required' means v2. 'optional' means v1. Use 'metadata\_enabled' to disable instance metadata alltogether. | `string` | `"required"` | no |
| <a name="input_ssh_cidr_range"></a> [ssh\_cidr\_range](#input\_ssh\_cidr\_range) | The CIDR range to allow SSH access from to your provisioned server. Can be a single IP address or a full CIDR range. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_ssh_port"></a> [ssh\_port](#input\_ssh\_port) | Port at which SSH is running on the server. Must match the sshd\_port from the Ansible playbook. | `number` | `22` | no |
| <a name="input_target_cidr_range"></a> [target\_cidr\_range](#input\_target\_cidr\_range) | The CIDR range you would like to accept traffic from. You can leave at the default, or optionally scope traffic exclusively from your target network. Use ssh\_cidr\_range to configure SSH connectivity. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_vpc_az"></a> [vpc\_az](#input\_vpc\_az) | Availability zone in the default VPC to create resources. | `string` | `"us-east-1a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kali_id"></a> [kali\_id](#output\_kali\_id) | n/a |
| <a name="output_kali_ip"></a> [kali\_ip](#output\_kali\_ip) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
