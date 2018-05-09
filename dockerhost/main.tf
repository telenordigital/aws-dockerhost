module "simple-server" {
  source = "../simple-server"

  account_name               = "${var.account_name}"
  additional_security_groups = "${var.additional_security_groups}"
  ami_name                   = "${var.ami_name}"
  aws_region                 = "${var.aws_region}"
  bastion_sg_id              = "${var.bastion_sg_id}"
  consul_service_name        = "${var.service_name}"
  common_sg_id               = "${var.common_sg_id}"
  dns_zone_id                = "${var.dns_zone_id}"
  instance_type              = "${var.instance_type}"
  subnet_ids                 = "${var.subnet_ids}"
  root_volume_size           = "${var.root_volume_size}"
  user_data                  = "${data.template_cloudinit_config.docker.rendered}"
  associate_ip               = "${var.associate_ip}"
  dns_public_ip              = "${var.dns_public_ip}"
}

locals {
  simple_server_arn = "arn:aws:iam::${var.account_id}:role/${module.simple-server.instance_iam_role_name}"
  bucket_name       = "${var.s3_secrets_bucket != "" ? var.s3_secrets_bucket : format("ssd-secrets-%s-%s",var.account_name,var.consul_service_name) }"
  bucket_arn        = "arn:aws:s3:::${local.bucket_name}"
}
