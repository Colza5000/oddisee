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

resource "aws_autoscaling_group" "openvpn" {
  name                      = "${var.service}-asg"
  max_size                  = "${var.max_capacity}"
  min_size                  = "${var.min_capacity}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.jenkins.name}"
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  load_balancers            = ["${aws_elb.openvpn-elb.id}"]

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "${var.service}"
    propagate_at_launch = true
  }
}