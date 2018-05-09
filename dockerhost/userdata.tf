data "template_file" "docker" {
  template = "${file("${path.module}/userdata.sh.tpl")}"

  vars {
    aws_region               = "${var.aws_region}"
    s3_secrets               = "${local.bucket_name}"
    mount_ebs                = "${var.ebs_volume_id == "" ? 0 : 1}"
    host_reboot_frequency    = "${var.host_reboot_frequency}"
    docker_restart_frequency = "${var.docker_restart_frequency}"
    frequency_offset         = "${var.frequency_offset}"
  }
}

data "template_cloudinit_config" "docker" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_compose}"
    filename     = "docker-compose.yml"
  }
}
