module "iam" {
  source      = "git::ssh://git@[GIT REPO URL]?ref=[GIT COMMIT REFERENCE]//path/to/module"
  name_prefix = "${var.service_name}-"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}

locals {
  instance_ip = "${var.dns_public_ip ? aws_instance.simple-server.public_ip : aws_instance.simple-server.private_ip}"
  record_ip   = "${var.associate_ip != "" ? var.associate_ip : local.instance_ip}"
}

resource "aws_instance" "simple-server" {
  ami                    = "${data.aws_ami.ami.id}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${module.iam.deploy_instance_profile_name}"
  vpc_security_group_ids = ["${var.bastion_sg_id}", "${var.common_sg_id}", "${var.additional_security_groups}"]
  subnet_id              = "${element(var.subnet_ids, count.index % length(var.subnet_ids))}"
  user_data              = "${var.user_data}"

  root_block_device {
    volume_size = "${var.root_volume_size}"
  }

  tags {
    Name      = "${var.service_name}"
    Owner     = "${var.owner_email}"
    ServiceId = "${var.service_name}"
  }
}
