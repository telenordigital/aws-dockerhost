data "aws_iam_policy_document" "ecr" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecr" {
  name        = "${var.service_name}-dockerhost-ecr-policy"
  description = "Allow access to ecr"
  policy      = "${data.aws_iam_policy_document.ecr.json}"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = "${module.simple-server.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.ecr.arn}"
}
