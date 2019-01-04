data "aws_ami" "jenkins_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}

resource "aws_launch_configuration" "jenkins" {
  name_prefix     = "jenkins-launch-config"
  image_id        = "${data.aws_ami.jenkins_ami}"
  image_id        = "m4.large"
  key_name        = "${var.key_name}"
  security_groups = "${var.security_groups}"

  lifecycle {
    create_before_destroy = true
  }
}
