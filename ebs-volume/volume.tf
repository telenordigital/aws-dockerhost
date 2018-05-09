resource "aws_ebs_volume" "volume" {
  count = "${var.volume_count}"

  availability_zone = "${var.availability_zones[count.index]}"
  encrypted         = "${var.volume_encrypt}"
  size              = "${var.volume_size}"
  type              = "${var.volume_type}"

  tags = {
    Name = "${var.volume_name}${count.index}"
  }

  provisioner "local-exec" {
    when = "destroy"

    command = "aws ec2 create-snapshot --volume-id ${self.id} --description \"${var.volume_name}${count.index} volume snapshot.\" --region ${var.aws_region}"
  }
}
