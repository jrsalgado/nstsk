resource "aws_alb" "ecs_load_balancer" {
  name            = "${var.app_env}-ecs_load_balancer"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnets

  tags = {
    Name = "ecs_load_balancer"
  }
}

resource "aws_alb_target_group" "ecs_target_group" {
  name     = "${var.app_env}-ecs_target_group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/wp-includes/images/blank.gif"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name = "ecs_target_group"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.ecs_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}
