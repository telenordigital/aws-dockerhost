# module required inputs
# ----------------------
variable "account_name" {
  description = "The human readable name for this account"
}

variable "account_id" {
  description = "The account the module is run in"
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

variable "service_name" {
  description = "Service name for this simple service in Consul"
}

variable "docker_compose" {
  description = "Rendered docker-compose.yml file"
}

variable "docker_compose_version" {
  description = "Version of docker-compose to use"
}

variable "docker_version" {
  description = "The version of Docker that should be used"
}

variable "dns_zone_id" {
  description = "Route53 zone ID where we'll place the DNS A record"
}

variable "subnet_ids" {
  description = "List of the available subnet ids"
  type        = "list"
}

variable "ami_name" {
  description = "The name of the AMI we are using"
}

variable "owner_email" {
  description = "The email address of the owner of the cluster"
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

variable "s3_secrets_bucket" {
  description = "A bucket for secrets for the docker container. defaults to ssd-secrets-var.account_name-var.consul_service_name"
  default     = ""
}

variable "ebs_volume_id" {
  description = "An EBS volume to attach to the ec2 instance. One only."
  default     = ""
}

variable "dns_public_ip" {
  description = "If true, the default DNS record (if not overridden by a provided elastic IP) is the instances public, not private IP."
  default     = false
}

variable "host_reboot_frequency" {
  description = "How often the host should automatically reboot. Units: hours."
  default     = 0
}

variable "docker_restart_frequency" {
  description = "How often the container should automatically be restarted. Units: hours."
  default     = 0
}

variable "frequency_offset" {
  description = "The phase offset of the host_reboot_frequency and docker_restart_frequency cycles. Units: minutes."
  default     = 10
}
