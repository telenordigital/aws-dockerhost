# module required inputs
# ----------------------
variable "account_name" {
  description = "The human readable name for this account"
}

variable "ami_name" {
  description = "The name of the AMI we are using"
}

variable "aws_region" {
  description = "AWS Region for this terraform setup"
}

variable "bastion_sg_id" {
  description = "ID of the bastion security group"
}

variable "common_sg_id" {
  description = "ID of the common security group"
}

variable "owner_email" {
  description = "The email address of the owner of the cluster"
}

variable "service_name" {
  description = "Service name for this simple service"
}

variable "dns_zone_id" {
  description = "Route53 zone ID where we'll place the DNS A record"
}

variable "subnet_ids" {
  description = "List of the available subnet ids"
  type        = "list"
}

variable "user_data" {
  description = "User data in rendered form to pass to the instance"
}

# module optional inputs
# ----------------------
variable "instance_type" {
  description = "The instance type for the server."
  default     = "t2.nano"
}

variable "additional_security_groups" {
  description = "Security Groups to associate in addition to common-infrastructure and bastion"
  type        = "list"
  default     = []
}

variable "root_volume_size" {
  description = "Size of the root storage volume"
  default     = 8
}

variable "associate_ip" {
  description = "Whether an IP to create a record for. Either an EIP is passed, or the private ip is set."
  default     = ""
}

variable "dns_public_ip" {
  description = "If true, the default DNS record (if not overridden by a provided elastic IP) is the instances public, not private IP."
  default     = false
}
