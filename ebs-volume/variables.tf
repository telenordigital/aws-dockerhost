variable "availability_zones" {
  description = "The availability zones to place the volumes in."
  type        = "list"
}

variable "volume_name" {
  description = "The name to put in the volume's tags. Will have a number appended based on count."
}

variable "volume_type" {
  description = "The type of EBS volume to create. See: docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html"
  default     = "st1"
}

variable "volume_count" {
  description = "Amount of EBS volumes to create."
}

variable "volume_size" {
  description = "Size of the EBS volume in GiB."
}

variable "volume_encrypt" {
  default = true
}

variable "aws_region" {}
