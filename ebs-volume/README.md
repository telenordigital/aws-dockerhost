# EBS Volume

This is a standard ebs volume used primarily to create ebs volumes for simple-server-docker.
The userdata or AMI must check to see if the ebs volume is formatted, then mount it.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability_zones | The availability zones to place the volumes in. | list | - | yes |
| aws_region |  | string | - | yes |
| volume_count | Amount of EBS volumes to create. | string | - | yes |
| volume_encrypt |  | string | `true` | no |
| volume_name | The name to put in the volume's tags. Will have a number appended based on count. | string | - | yes |
| volume_size | Size of the EBS volume in GiB. | string | - | yes |
| volume_type | The type of EBS volume to create. See: docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html | string | `st1` | no |

## Outputs

| Name | Description |
|------|-------------|
| volume_ids |  |

