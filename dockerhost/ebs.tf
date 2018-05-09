resource "aws_volume_attachment" "dockerhost_ebs_volume" {
  count       = "${var.ebs_volume_id == "" ? 0 : 1}"
  device_name = "/dev/sdh"
  instance_id = "${module.simple-server.instance_id}"
  volume_id   = "${var.ebs_volume_id}"

  provisioner "local-exec" {
    when = "destroy"

    command = "aws ssm send-command --document-name \"${aws_ssm_document.ebs_deprovision_doc.name}\" --instance-ids \"${self.instance_id}\" --timeout-seconds 600 --region ${var.aws_region}"
  }

  provisioner "local-exec" {
    when = "destroy"

    command = "aws ec2 create-snapshot --volume-id ${self.volume_id} --description \"DockerhostEBS${var.consul_service_name} volume snapshot.\" --region ${var.aws_region}"
  }
}

resource "aws_ssm_document" "ebs_deprovision_doc" {
  name          = "DeprovisionDockerhostEBS-${var.service_name}"
  document_type = "Command"

  content = <<DOC
 {
     "schemaVersion":"1.2",
     "description":"Stop all Docker containers and unmount EBS volume.",
     "runtimeConfig":{
         "aws:runShellScript":{
             "properties":[
                 {
                     "id":"0.aws:runShellScript",
                     "runCommand":[
                         "sudo docker stop -t 20 $(docker ps -aq)",
                         "sudo systemctl stop docker",
                         "sudo umount /mnt/ebs"],
                     "timeoutSeconds":"300"
                 }
             ]
         }
     }
 }
DOC
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = "${module.simple-server.instance_iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
