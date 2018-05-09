output "instance_id" {
  value = "${aws_instance.simple-server.id}"
}

output "instance_private_ip" {
  value = "${aws_instance.simple-server.private_ip}"
}

output "instance_public_ip" {
  value = "${aws_instance.simple-server.public_ip}"
}

output "instance_iam_role_name" {
  value = "${module.iam.deploy_role_name}"
}

output "dns_name" {
  value = "${aws_route53_record.simple-server.name}"
}
