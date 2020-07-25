## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.70 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kali\_pubkey | The public key to a private key under your control. You will SSH onto the server using this keypair. | `string` | n/a | yes |
| ebs\_kms\_key | KMS key alias to use for KMS key data source. Defaults to the default AWS-managed EBS key. | `string` | `"aws/ebs"` | no |
| kali\_instance\_type | The EC2 instance size to use for the Kali server. | `string` | `"t2.medium"` | no |
| kali\_spot\_type | Whether to launch the Kali spot instance as a 'persistent' request or a 'one-time' request. | `string` | `"one-time"` | no |
| kali\_volume\_size | The volume size for the Kali EC2 instance, GiB. | `number` | `25` | no |
| metadata\_enabled | Whether EC2 instance medata is enabled. 'enabled' or 'disabled'. Use 'metadat\_tokens' to decide between v1 or v2 of instance metadata. | `string` | `"enabled"` | no |
| metadata\_hop\_limit | The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. It is recommended to leave this at '1'. | `number` | `1` | no |
| metadata\_tokens | Whether EC2 instance metadata is v1 or v2. 'required' means v2. 'optional' means v1. Use 'metadata\_enabled' to disable instance metadata alltogether. | `string` | `"required"` | no |
| ssh\_cidr\_range | The CIDR range to allow SSH access from to your provisioned server. Can be a single IP address or a full CIDR range. | `string` | `"0.0.0.0/0"` | no |
| ssh\_port | Port at which SSH is running on the server. Must match the sshd\_port from the Ansible playbook. | `number` | `2242` | no |
| target\_cidr\_range | The CIDR range you would like to accept traffic from. You can leave at the default, or optionally scope traffic exclusively from your target network. Use ssh\_cidr\_range to configure SSH connectivity. | `string` | `"0.0.0.0/0"` | no |
| vpc\_az | Availability zone in the default VPC to create resources. | `string` | `"us-east-1a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| kali\_id | n/a |
| kali\_ip | n/a |
