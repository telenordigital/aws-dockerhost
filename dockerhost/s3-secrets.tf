resource "aws_s3_bucket" "docker-secrets" {
  count  = "${var.s3_secrets_bucket == "" ? 1 : 0 }"
  bucket = "${local.bucket_name}"

  versioning {
    enabled = true
  }

  tags {
    Owner = "${var.owner_email}"
  }
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = "${module.simple-server.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.s3_policy.arn}"
}

resource "aws_iam_policy" "s3_policy" {
  name_prefix = "dockerhost-s3secrets-${var.service_name}"
  description = "A policy to allow a dockerhost ec2 (${var.service_name}) instances RO access to their respective secrets bucket"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${local.bucket_arn}",
        "${local.bucket_arn}/*"
    ]
    }
  ]
}
POLICY
}
