output "instance_id" {
  value = "${module.simple-server.instance_id}"
}

output "instance_private_ip" {
  value = "${module.simple-server.instance_private_ip}"
}

output "instance_iam_role_name" {
  value = "${module.simple-server.instance_iam_role_name}"
}

output "instance_public_ip" {
  value = "${module.simple-server.instance_public_ip}"
}

output "dns_name" {
  value = "${module.simple-server.dns_name}"
}
