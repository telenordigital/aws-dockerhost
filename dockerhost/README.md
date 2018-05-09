THE REBOOT/RESTART TIMERS DON'T WORK.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account_id | The account the module is run in | string | - | yes |
| account_name | The human readable name for this account | string | - | yes |
| additional_security_groups | Security Groups to associate in addition to common-infrastructure and bastion | list | `<list>` | no |
| ami_name | The name of the AMI we are using | string | - | yes |
| associate_ip | Whether an IP to create a record for. Either an EIP is passed, or the private ip is set. | string | `` | no |
| aws_region | AWS Region for this terraform setup | string | - | yes |
| bastion_sg_id | ID of the bastion security group | string | - | yes |
| common_sg_id | ID of the common security group | string | - | yes |
| dns_public_ip | If true, the default DNS record (if not overridden by a provided elastic IP) is the instances public, not private IP. | string | `false` | no |
| dns_zone_id | Route53 zone ID where we'll place the DNS A record | string | - | yes |
| docker_compose | Rendered docker-compose.yml file | string | - | yes |
| docker_compose_version | Version of docker-compose to use | string | - | yes |
| docker_restart_frequency | How often the container should automatically be restarted. Units: hours. | string | `0` | no |
| docker_version | The version of Docker that should be used | string | - | yes |
| ebs_volume_id | An EBS volume to attach to the ec2 instance. One only. | string | `` | no |
| frequency_offset | The phase offset of the host_reboot_frequency and docker_restart_frequency cycles. Units: minutes. | string | `10` | no |
| host_reboot_frequency | How often the host should automatically reboot. Units: hours. | string | `0` | no |
| instance_type | The instance type for the server. | string | `t2.nano` | no |
| owner_email | The email address of the owner of the cluster | string | - | yes |
| root_volume_size | Size of the root storage volume | string | `8` | no |
| s3_secrets_bucket | A bucket for secrets for the docker container. defaults to ssd-secrets-var.account_name-var.consul_service_name | string | `` | no |
| service_name | Service name for this simple service in Consul | string | - | yes |
| subnet_ids | List of the available subnet ids | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns_name |  |
| instance_iam_role_name |  |
| instance_id |  |
| instance_private_ip |  |
| instance_public_ip |  |

