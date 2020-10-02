resource "aws_key_pair" "keypair" {
  key_name   = "keypair-${var.app_env}"
  public_key = file("${path.root}/files/id_rsa_evaluator.pub")
}

resource "aws_autoscaling_group" "wordpress" {
  name                      = "${var.app_env}-asg"
  desired_capacity          = var.size
  min_size                  = var.size
  max_size                  = var.size
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.wordpress.name
  vpc_zone_identifier       = var.public_subnets

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

resource "aws_launch_configuration" "wordpress" {
  name_prefix                 = "${var.app_env}-lc"
  image_id                    = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  ebs_optimized               = false

  security_groups = [
    aws_security_group.wordpress.id
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "wordpress" {
  name        = "${var.app_env}-allow-ssh-sg"
  vpc_id      = var.vpc_id
  description = "Inboud and outbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_env}-allow-incoming-traffic-sg"
    Environment = var.app_env
    Terraform   = "true"
  }
}

resource "aws_security_group" "mysql" {
  name        = "${var.app_env}-mysql-sg"
  description = "Inboud traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_env}-mysql-sg"
  }
}

resource "aws_instance" "mysql" {
  ami           = var.ami
  instance_type = "t3.micro"
  key_name      = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [ aws_security_group.mysql.id ]
  subnet_id = var.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name = "${var.app_env}-mysql",
    Environment = var.app_env
  }
}
