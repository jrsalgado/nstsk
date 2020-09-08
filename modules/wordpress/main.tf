data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "01_start_wordpress_server.sh"
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/files/start_wordpress_server.sh")}"
  }
}

resource "aws_autoscaling_group" "wordpress_test" {
  name                      = "${var.app_env}-asg"
  desired_capacity          = var.size
  min_size                  = var.size
  max_size                  = var.size
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.wordpress_test.name
  vpc_zone_identifier       = ["${var.private_subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.app_env}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.app_env
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "wordpress_test" {
  name_prefix                 = "${var.app_env}-lc"
  image_id                    = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data                   = data.template_cloudinit_config.user_data.rendered
  associate_public_ip_address = false
  ebs_optimized               = false

  security_groups = [
    "${aws_security_group.wordpress_test.id}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "wordpress_test" {
  name        = "${var.app_env}-allow-ssh-sg"
  vpc_id      = var.vpc_id
  description = "SSH inbound only and egress"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allow_ssh_cidr_block}"]
  }

  tags {
    Name        = "${var.app_env}-allow-ssh-sg"
    Environment = var.app_env
    Terraform   = "true"
  }
}


