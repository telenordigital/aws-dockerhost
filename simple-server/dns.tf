resource "aws_route53_record" "simple-server" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.service_name}.${var.account_name}.[YOUR DOMAIN]"
  type    = "A"
  ttl     = "600"
  records = ["${local.record_ip}"]
}
